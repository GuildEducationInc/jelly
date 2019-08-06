# frozen_string_literal: true

require_relative './node'

module Donut
  module GraphQL
    module Types
      class Token < ::Donut::GraphQL::Types::Node
        field :access_token, String, null: false
        field :token_type, String, null: false
        field :expires_in, Integer, null: true
        field :refresh_token, Integer, null: true
      end
    end
  end
end
