# frozen_string_literal: true

require_relative './node'

module Donut
  module GraphQL
    module Types
      class Talk < ::Donut::GraphQL::Types::Node
        field :topic, String, null: false
        field :description, String, null: false
        field :votes_count, Integer, null: false
        field :voter_ids, [::GraphQL::Types::ID], null: false
      end
    end
  end
end
