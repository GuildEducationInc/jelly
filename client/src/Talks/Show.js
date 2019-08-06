import React from "react";
import Button from "react-bootstrap/Button";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import ListGroup from "react-bootstrap/ListGroup";
import IosThumbsUpOutline from "react-ionicons/lib/IosThumbsUpOutline";
import { Mutation } from "react-apollo";
import { loader } from "graphql.macro";

const talkVoteMutation = loader("./graphql/mutations/TalkVote.graphql");

export default ({ talk }) => {
  const { id, votes, topic, gid, description } = talk;

  return (
    <ListGroup.Item as="li" className="lh-condensed">
      <Row>
        <Col
          xs={1}
          className="pl-4 text-center d-flex flex-column justify-content-center"
        >
          <strong className="font-weight-bold text-gray">{votes}</strong>
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
                    variables: { id, direction: "UP" },
                    optimisticResponse: {
                      __typename: "Mutation",
                      talkVote: {
                        errors: [],
                        talk: {
                          id,
                          gid,
                          topic,
                          description,
                          votes: votes + 1,
                          __typename: "Talk"
                        },
                        __typename: "TalkVotePayload"
                      }
                    }
                  })
                }
              >
                <IosThumbsUpOutline color="#0b5271" />
              </Button>
            )}
          </Mutation>
        </Col>
        <Col xs={6} className="d-flex flex-column justify-content-center">
          <h6 className="my-0 font-weight-bold">{topic}</h6>
          <small className="text-muted">{description}</small>
        </Col>
      </Row>
    </ListGroup.Item>
  );
};