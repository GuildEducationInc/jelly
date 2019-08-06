import React from "react";
import { Query } from "react-apollo";
import List from "./List";
import { filter, sortBy, isEmpty } from "lodash";
import moment from "moment";
import { loader } from "graphql.macro";

export const talksQuery = loader("./graphql/queries/Talks.graphql");

function chunk(talks) {
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

  return { upcoming, past, backlog };
}

export default () => (
  <Query query={talksQuery}>
    {({ loading, error, data }) => {
      if (loading) return <div className="loader">Loading...</div>;
      if (error) return <p>Error :(</p>;

      const {
        talks: { nodes: talks }
      } = data;

      const { upcoming, past, backlog } = chunk(talks);

      return (
        <>
          {isEmpty(upcoming) ? (
            ""
          ) : (
            <section className="mb-4">
              <h2 className="h6 text-muted ml-2">Upcoming</h2>
              <List talks={upcoming} />
            </section>
          )}

          <section className="mb-4">
            <h2 className="h6 text-muted ml-2">Backlog</h2>
            <List talks={backlog} />
          </section>

          {isEmpty(past) ? (
            ""
          ) : (
            <section>
              <h2 className="h6 text-muted ml-2">Past</h2>
              <List talks={past} />
            </section>
          )}
        </>
      );
    }}
  </Query>
);
