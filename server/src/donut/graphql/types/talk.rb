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
        field :scheduled_for, ::GraphQL::Types::ISO8601DateTime, null: true
        field :links, [String], null: false

        def scheduled_for
          return nil unless object[:scheduled_for].present?

          Time.parse object[:scheduled_for]
        end
      end
    end
  end
end
