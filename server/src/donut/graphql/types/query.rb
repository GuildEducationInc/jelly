# frozen_string_literal: true

require_relative './talk'
require_relative '../../services/talks/query'

module Donut
  module GraphQL
    module Types
      class Query < ::GraphQL::Schema::Object
        add_field ::GraphQL::Types::Relay::NodeField
        add_field ::GraphQL::Types::Relay::NodesField

        field :talks, ::Donut::GraphQL::Types::Talk.connection_type, null: false

        def talks
          result = services[:talks].call
          return unless result.success?

          result.value
        end

        private

        def services
          {
            talks: ::Donut::Services::Talks::Query
          }
        end
      end
    end
  end
end
