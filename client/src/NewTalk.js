import React from "react";
import Form from "react-bootstrap/Form";
import Button from "react-bootstrap/Button";
import { gql } from "apollo-boost";
import { Mutation } from "react-apollo";
import uuidv4 from "uuid/v4";
import { talksQuery } from "./Talks";

const talkCreateMutation = gql`
  mutation TalkCreate($topic: String!, $description: String!) {
    talkCreate(input: { topic: $topic, description: $description }) {
      talk {
        id
        gid
        topic
        votes
        description
      }
      errors
    }
  }
`;

const NewTalk = () => {
  let topicInput, descriptionInput;

  return (
    <Mutation mutation={talkCreateMutation}>
      {talkCreate => (
        <Form
          className="mb-4"
          onSubmit={e => {
            e.preventDefault();
            const id = uuidv4();

            talkCreate({
              variables: {
                topic: topicInput.value,
                description: descriptionInput.value
              },
              update(
                proxy,
                {
                  data: {
                    talkCreate: { talk }
                  }
                }
              ) {
                const data = proxy.readQuery({ query: talksQuery });

                proxy.writeQuery({
                  query: talksQuery,
                  data: {
                    ...data,
                    talks: {
                      ...data.talks,
                      nodes: [...data.talks.nodes, talk]
                    }
                  }
                });
              },
              optimisticResponse: {
                __typename: "Mutation",
                talkCreate: {
                  errors: [],
                  talk: {
                    id,
                    gid: `gid://donut/talk/${id}`,
                    topic: topicInput.value,
                    description: descriptionInput.value,
                    votes: 0,
                    __typename: "Talk"
                  },
                  __typename: "TalkCreatePayload"
                }
              }
            });

            topicInput.value = null;
            descriptionInput.value = null;
          }}
        >
          <Form.Group controlId="talk_topic">
            <Form.Control
              type="text"
              placeholder="Topic"
              ref={node => {
                topicInput = node;
              }}
            />
          </Form.Group>

          <Form.Group controlId="talk_description">
            <Form.Control
              as="textarea"
              rows="3"
              type="text"
              placeholder="Description"
              ref={node => {
                descriptionInput = node;
              }}
            />
          </Form.Group>
          <Button variant="primary" block={true} type="submit">
            Submit
          </Button>
        </Form>
      )}
    </Mutation>
  );
};

export default NewTalk;
