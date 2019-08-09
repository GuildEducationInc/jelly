import ApolloClient from "apollo-client";
import { createHttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { setContext } from "apollo-link-context";

const httpLink = createHttpLink({
  uri: process.env.GRAPHQL_SERVER || "http://localhost:4567/graphql"
});

const authLink = setContext((_, { headers }) => {
  const session = localStorage.getItem("redux-react-session/USER-SESSION");

  if (!session) {
    return { headers };
  }

  const { token, tokenType } = JSON.parse(session);

  return {
    headers: {
      ...headers,
      authorization: `${tokenType} ${token}`
    }
  };
});

export default new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
});
