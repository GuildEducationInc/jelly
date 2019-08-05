import React from "react";
import ListGroup from "react-bootstrap/ListGroup";
import Talk from "./Talk";
import { map, sortBy } from "lodash";

const TalksList = ({ talks }) => {
  const list = map(sortBy(talks, ({ votes }) => -votes), talk => (
    <Talk talk={talk} key={talk.id} />
  ));

  return <ListGroup as="ul">{list}</ListGroup>;
};

export default TalksList;
