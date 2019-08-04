# frozen_string_literal: true

require_relative './graphql/schema'

module Donut
  class App < ::Sinatra::Base
    configure do
      set :server, :puma
      enable :logging
    end

    post '/graphql' do
      body = JSON.parse request.body.read

      json ::Donut::GraphQL::Schema.execute(
        body['query'],
        variables: body['variables']
      )
    end
  end
end
