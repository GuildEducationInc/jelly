import React from "react";
import { Query } from "react-apollo";
import { gql } from "apollo-boost";
import TalksList from "./TalksList";
import { filter, sortBy, isEmpty } from "lodash";
import moment from "moment";

export const talksQuery = gql`
  query Talks {
    talks {
      nodes {
        id
        gid
        topic
        description
        votes
      }
    }
  }
`;

const Talks = () => (
  <Query query={talksQuery}>
    {({ loading, error, data }) => {
      if (loading) return <div className="loader">Loading...</div>;
      if (error) return <p>Error :(</p>;

      const {
        talks: { nodes: talks }
      } = data;

      const upcoming = sortBy(
        filter(talks, ({ scheduledFor }) => moment(scheduledFor).isAfter()),
        "scheduledFor"
      );

      const past = sortBy(
        filter(talks, ({ scheduledFor }) => moment(scheduledFor).isBefore()),
        "scheduledFor"
      );

      const backlog = sortBy(
        filter(talks, ({ scheduledFor }) => isEmpty(scheduledFor)),
        ({ votes }) => -votes
      );

      return (
        <>
          {isEmpty(upcoming) ? (
            ""
          ) : (
            <section className="mb-4">
              <h2 className="h6 text-muted ml-2">Upcoming</h2>
              <TalksList talks={upcoming} />
            </section>
          )}

          <section className="mb-4">
            <h2 className="h6 text-muted ml-2">Backlog</h2>
            <TalksList talks={backlog} />
          </section>

          {isEmpty(past) ? (
            ""
          ) : (
            <section>
              <h2 className="h6 text-muted ml-2">Past</h2>
              <TalksList talks={past} />
            </section>
          )}
        </>
      );
    }}
  </Query>
);

export default Talks;
