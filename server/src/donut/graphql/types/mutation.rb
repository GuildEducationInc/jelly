# frozen_string_literal: true

require_relative '../mutations/talk_create'
require_relative '../mutations/talk_vote'

module Donut
  module GraphQL
    module Types
      class Mutation < ::GraphQL::Schema::Object
        field :talk_create, mutation: ::Donut::GraphQL::Mutations::TalkCreate
        field :talk_vote, mutation: ::Donut::GraphQL::Mutations::TalkVote
      end
    end
  end
end
