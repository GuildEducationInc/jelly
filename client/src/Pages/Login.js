import React, { Component } from "react";
import { Container, Row } from "react-bootstrap";
import { loader } from "graphql.macro";
import apollo from "../graphql/apollo";
import { sessionService } from "redux-react-session";
import logo from "../images/logo.svg";

const sessionCreateMutation = loader(
  "../graphql/mutations/SessionCreate.graphql"
);

export default class Login extends Component {
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
    const {
      props: { history }
    } = this;

    const googleIdToken = googleUser.getAuthResponse().id_token;

    const res = await apollo.mutate({
      mutation: sessionCreateMutation,
      variables: { googleIdToken }
    });

    const {
      data: { sessionCreate: session }
    } = res;
    const { errors } = session;

    if (errors.length) {
      sessionService.deleteSession();
      sessionService.deleteUser();
      history.push("/login");
      alert("unable to authenticate");
      return;
    }

    const {
      token: { accessToken: token, tokenType },
      user
    } = session;

    await sessionService.saveSession({ token, tokenType });
    await sessionService.saveUser(user);

    history.push("/");
  }

  render() {
    return (
      <Container className="pt-5">
        <Row className="justify-content-center mb-4">
          <img src={logo} alt="logo" width={100} />
        </Row>
        <Row className="justify-content-center">
          <div id="g-signin2" />
        </Row>
      </Container>
    );
  }
}
