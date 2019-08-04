# frozen_string_literal: true

require_relative './node'

module Donut
  module GraphQL
    module Types
      class Talk < ::Donut::GraphQL::Types::Node
        field :topic, String, null: true
        field :votes, Integer, null: false
      end
    end
  end
end
