import React from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Redirect
} from "react-router-dom";
import { ApolloProvider } from "react-apollo";
import apollo from "./graphql/apollo";
import Home from "./Pages/Home";
import Login from "./Pages/Login";
import PrivateRoute from "./Components/PrivateRoute";
import { createStore, combineReducers } from "redux";
import { sessionReducer as session, sessionService } from "redux-react-session";
import { Provider, connect } from "react-redux";
import { loader } from "graphql.macro";

const reducers = { session };
const reducer = combineReducers(reducers);
const store = createStore(reducer);
const redirectToApp = () => <Redirect to="/app" />;
const mapState = state => state;
export const meQuery = loader("./graphql/queries/Me.graphql");

const opts = {
  redirectPath: "/login",
  driver: "LOCALSTORAGE"
};

sessionService.initSessionService(store, opts);

const Routes = connect(mapState)(({ session: { authenticated, checked } }) => {
  return (
    <Router>
      <ApolloProvider client={apollo}>
        {checked && (
          <main>
            <Switch>
              <PrivateRoute
                exact={true}
                authenticated={authenticated}
                path="/app"
                component={Home}
              />
              <Route
                exact={true}
                path="/login"
                component={authenticated ? redirectToApp : Login}
              />
              <Route component={redirectToApp} />
            </Switch>
          </main>
        )}
      </ApolloProvider>
    </Router>
  );
});

export default () => (
  <Provider store={store}>
    <Routes />
  </Provider>
);
