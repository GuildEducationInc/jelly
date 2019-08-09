import React from "react";
import { Container, Row, Col } from "react-bootstrap";
import Talks from "./Talks/Index";
import NewTalk from "./Talks/New";
import Navbar from "../Components/Navbar";
import { connect } from "react-redux";

const mapState = ({ session: { user } }) => {
  return { user };
};

const Home = ({ user: { profilePictureUrl } }) => {
  return (
    <>
      <Navbar profilePictureUrl={profilePictureUrl} />
      <Container className="pt-4">
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
      </Container>
    </>
  );
};

export default connect(mapState)(Home);