import React, { Component } from "react";
import ApolloClient from "apollo-client";
import { createHttpLink } from "apollo-link-http";
import { ApolloProvider } from "react-apollo";
import { InMemoryCache } from "apollo-cache-inmemory";
import { setContext } from "apollo-link-context";
import Container from "react-bootstrap/Container";
import Talks from "./Talks/Index";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import NewTalk from "./Talks/New";
import Navbar from "./Navbar";
import { loader } from "graphql.macro";

const sessionCreateMutation = loader(
  "./App/graphql/mutations/SessionCreate.graphql"
);

const httpLink = createHttpLink({
  uri: "http://localhost:4567/graphql"
});

const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem("token");

  if (!token) {
    return { headers };
  }

  const { accessToken, tokenType } = JSON.parse(token);

  return {
    headers: {
      ...headers,
      authorization: `${tokenType} ${accessToken}`
    }
  };
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
});

class App extends Component {
  constructor(props) {
    super(props);

    this.state = { session: null };
  }

  componentDidMount() {
    this.renderSignInButton();
  }

  renderSignInButton() {
    window.gapi.signin2.render("g-signin2", {
      scope: "profile email",
      height: 30,
      onsuccess: this.onSignIn.bind(this)
    });
  }

  async onSignIn(googleUser) {
    const googleIdToken = googleUser.getAuthResponse().id_token;
    const res = await client.mutate({
      mutation: sessionCreateMutation,
      variables: { googleIdToken }
    });

    const {
      data: { sessionCreate: session }
    } = res;
    const { errors } = session;

    if (errors.length) {
      localStorage.removeItem("token");
      this.setState({ session: null });
      alert("unable to authenticate");
      return;
    }

    localStorage.setItem("token", JSON.stringify(session.token));
    this.setState({ session });
  }

  render() {
    const {
      state: { session }
    } = this;

    const app = (
      <Row>
        <Col xs={8}>
          <Talks />
        </Col>
        <Col>
          <h2 className="h6 text-muted ml-2">Request/Submit a Talk</h2>
          <NewTalk />
          <div className="text-muted text-center">
            <small>
              Questions? Thoughts? Feedback? <br />
              Contact{" "}
              <a href="slack://user?team=T0G6T8SLC&id=UHEJ461A9">
                @Justin Chapman
              </a>{" "}
              or <a href="slack://user?team=T0G6T8SLC&id=UH49NMU6M">@Trey</a>
            </small>
          </div>
        </Col>
      </Row>
    );

    return (
      <ApolloProvider client={client}>
        {session ? (
          <>
            <Navbar profilePictureUrl={session.user.profilePictureUrl} />
            <Container className="pt-4">{app}</Container>
          </>
        ) : (
          <Container className="d-flex justify-content-center mt-5">
            <div id="g-signin2" />
          </Container>
        )}
      </ApolloProvider>
    );
  }
}

export default App;
