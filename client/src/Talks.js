import React from "react";
import { Query } from "react-apollo";
import { gql } from "apollo-boost";
import TalksList from "./TalksList";

const query = gql`
  {
    talks {
      nodes {
        id
        gid
        topic
        votes
      }
    }
  }
`;

const Talks = () => (
  <Query query={query}>
    {({ loading, error, data }) => {
      if (loading) return <div className="loader">Loading...</div>;
      if (error) return <p>Error :(</p>;

      const {
        talks: { nodes: talks }
      } = data;

      return (
        <>
          <section className="mb-4">
            <h2 className="h6 text-muted ml-2">Upcoming</h2>
            <TalksList talks={talks} />
          </section>
          <section className="mb-4">
            <h2 className="h6 text-muted ml-2">Backlog</h2>
            <TalksList talks={talks} />
          </section>
          <section>
            <h2 className="h6 text-muted ml-2">Past</h2>
            <TalksList talks={talks} />
          </section>
        </>
      );
    }}
  </Query>
);

export default Talks;
