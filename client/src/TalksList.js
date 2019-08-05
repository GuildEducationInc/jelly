import React from "react";
import ListGroup from "react-bootstrap/ListGroup";
import Talk from "./Talk";
import { map, isEmpty } from "lodash";

const TalksList = ({ talks }) => {
  if (isEmpty(talks)) {
    return (
      <ListGroup as="ul">
        <ListGroup.Item as="li" className="border-0 px-2 bg-transparent">
          <small className="text-muted">No talks</small>
        </ListGroup.Item>
      </ListGroup>
    );
  } else {
    const list = map(talks, talk => <Talk talk={talk} key={talk.id} />);
    return <ListGroup as="ul">{list}</ListGroup>;
  }
};

export default TalksList;
