# frozen_string_literal: true

Dir["#{__dir__}/../mutations/**/*.rb"].each { |f| require f }

module Jelly
  module GraphQL
    module Types
      class Mutation < ::GraphQL::Schema::Object
        field :session_create,
              mutation: ::Jelly::GraphQL::Mutations::SessionCreate
        field :talk_create,
              mutation: ::Jelly::GraphQL::Mutations::TalkCreate
        field :talk_vote,
              mutation: ::Jelly::GraphQL::Mutations::TalkVote
        field :talk_update,
              mutation: ::Jelly::GraphQL::Mutations::TalkUpdate
      end
    end
  end
end
