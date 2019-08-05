import React, { Component } from "react";
import ApolloClient from "apollo-boost";
import { ApolloProvider } from "react-apollo";
import Container from "react-bootstrap/Container";
import Talks from "./Talks";
import logo from "./images/logo.svg";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Image from "react-bootstrap/Image";
import Navbar from "react-bootstrap/Navbar";
import Alert from "react-bootstrap/Alert";
import NewTalk from "./NewTalk";

const client = new ApolloClient({
  uri: "http://localhost:4567/graphql"
});

class App extends Component {
  constructor(props) {
    super(props);

    this.state = { session: { currentUser: null, isAuthenticated: false } };
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

  onSignIn(currentUser) {
    this.setState({ isAuthenticated: true, currentUser });
  }

  render() {
    const {
      state: { isAuthenticated }
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
        <Navbar bg="white" expand="lg" className="shadow-sm">
          <Container>
            <Navbar.Brand href="#" className="mr-auto">
              <img
                src={logo}
                alt="logo"
                className="d-inline-block align-top"
                height="30"
              />
            </Navbar.Brand>
            <Navbar.Brand href="#">
              {isAuthenticated ? (
                <Image
                  src={this.state.currentUser.getBasicProfile().getImageUrl()}
                  roundedCircle={true}
                  alt="avatar"
                  className="d-inline-block align-top"
                  height="30"
                />
              ) : (
                <div className="d-flex justify-content-center py-0 my-0">
                  <div id="g-signin2" className="d-inline-block" />
                </div>
              )}
            </Navbar.Brand>
          </Container>
        </Navbar>
        <Container className="pt-4">
          {isAuthenticated ? (
            app
          ) : (
            <Alert variant="primary" className="text-center">
              Please sign in to get started
            </Alert>
          )}
        </Container>
      </ApolloProvider>
    );
  }
}

export default App;
