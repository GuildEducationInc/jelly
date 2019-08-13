# frozen_string_literal: true

Dir["#{__dir__}/../mutations/**/*.rb"].each { |f| require f }

module Donut
  module GraphQL
    module Types
      class Mutation < ::GraphQL::Schema::Object
        field :session_create,
              mutation: ::Donut::GraphQL::Mutations::SessionCreate
        field :talk_create,
              mutation: ::Donut::GraphQL::Mutations::TalkCreate
        field :talk_vote,
              mutation: ::Donut::GraphQL::Mutations::TalkVote
        field :talk_update,
              mutation: ::Donut::GraphQL::Mutations::TalkUpdate
      end
    end
  end
end
