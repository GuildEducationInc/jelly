import React from "react";
import Image from "react-bootstrap/Image";
import Navbar from "react-bootstrap/Navbar";
import logo from "../images/logo.svg";
import Container from "react-bootstrap/Container";

export default ({ profilePictureUrl }) => (
  <Navbar bg="white" expand="lg" className="shadow-sm" fixed="top">
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
        <Image
          src={profilePictureUrl}
          roundedCircle={true}
          alt="avatar"
          className="d-inline-block align-top"
          height="30"
        />
      </Navbar.Brand>
    </Container>
  </Navbar>
);
