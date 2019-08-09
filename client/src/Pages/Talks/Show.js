import React from "react";
import Button from "react-bootstrap/Button";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import ListGroup from "react-bootstrap/ListGroup";
import IosThumbsUpOutline from "react-ionicons/lib/IosThumbsUpOutline";
import IosThumbsUp from "react-ionicons/lib/IosThumbsUp";
import { Mutation } from "react-apollo";
import { loader } from "graphql.macro";
import { connect } from "react-redux";
import moment from "moment";

const talkVoteMutation = loader("../../graphql/mutations/TalkVote.graphql");

const mapState = ({ session: { user } }) => {
  return { user };
};

const ShowTalk = ({ talk, user: { id: currentUserId } }) => {
  const {
    id,
    votesCount,
    topic,
    gid,
    description,
    voterIds,
    scheduledFor
  } = talk;
  const voters = new Set(voterIds);

  return (
    <ListGroup.Item as="li" className="lh-condensed">
      <Row>
        <Col
          xs={1}
          className="pl-4 text-center d-flex flex-column justify-content-center"
        >
          <strong className="font-weight-bold text-gray">{votesCount}</strong>
        </Col>
        <Col
          xs={1}
          className="px-0 text-center d-flex flex-column justify-content-center"
        >
          <Mutation mutation={talkVoteMutation}>
            {talkVote => (
              <Button
                variant="link"
                onClick={() =>
                  talkVote({
                    variables: {
                      id,
                      direction: voters.has(currentUserId) ? "DOWN" : "UP"
                    },
                    optimisticResponse: {
                      __typename: "Mutation",
                      talkVote: {
                        errors: [],
                        talk: {
                          id,
                          gid,
                          topic,
                          description,
                          scheduledFor,
                          votesCount: voters.has(currentUserId)
                            ? votesCount - 1
                            : votesCount + 1,
                          voterIds: voters.has(currentUserId)
                            ? [
                                (() => {
                                  const ids = new Set(voterIds);
                                  ids.delete(currentUserId);
                                  return new Array(ids);
                                })()
                              ]
                            : [...voterIds, currentUserId],
                          __typename: "Talk"
                        },
                        __typename: "TalkVotePayload"
                      }
                    }
                  })
                }
              >
                {voters.has(currentUserId) ? (
                  <IosThumbsUp color="#0b5271" />
                ) : (
                  <IosThumbsUpOutline color="#0b5271" />
                )}
              </Button>
            )}
          </Mutation>
        </Col>
        <Col xs={6} className="d-flex flex-column justify-content-center">
          {scheduledFor && (
            <small className="mb-1">{moment(scheduledFor).format("lll")}</small>
          )}
          <h6 className="my-0 mb-1 font-weight-bold">{topic}</h6>
          <small className="text-muted">{description}</small>
        </Col>
      </Row>
    </ListGroup.Item>
  );
};

export default connect(mapState)(ShowTalk);
