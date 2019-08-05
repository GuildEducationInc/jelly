import React from "react";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "react-apollo";
import Container from "react-bootstrap/Container";
import Talks from "./Talks";
import logo from "./images/logo.svg";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Form from "react-bootstrap/Form";
import Button from "react-bootstrap/Button";

const client = new ApolloClient({
  uri: "http://localhost:4567/graphql"
});

const App = () => (
  <ApolloProvider client={client}>
    <Container className="pt-4">
      <div className="text-center mb-4">
        <img src={logo} alt="logo" className="float-center mb-2" height="60" />
      </div>
      <Row>
        <Col xs={8}>
          <Talks />
        </Col>
        <Col>
          <h2 className="h6 text-muted ml-2">Request/Submit a Talk</h2>
          <Form className="mb-4">
            <Form.Group controlId="talk_topic">
              <Form.Control type="text" placeholder="Topic" />
            </Form.Group>

            <Form.Group controlId="talk_description">
              <Form.Control
                as="textarea"
                rows="3"
                type="text"
                placeholder="Description"
              />
            </Form.Group>
            <Button variant="primary" block={true} type="submit">
              Submit
            </Button>
          </Form>
          <div className="text-muted text-center">
            <small>
              Questions? Thoughts? Feedback? <br />
              Contact{" "}
              <a href="slack://user?team={TEAM_ID}&id={USER_ID}">
                @Justin Chapman
              </a>{" "}
              or <a href="slack://user?team={TEAM_ID}&id={USER_ID}">@Trey</a>
            </small>
          </div>
        </Col>
      </Row>
    </Container>
  </ApolloProvider>
);

export default App;
