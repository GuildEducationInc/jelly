# frozen_string_literal: true

require_relative './talk'
require_relative '../../services/talks/query'
require_relative '../../services/talks/find'

module Jelly
  module GraphQL
    module Types
      class Query < ::GraphQL::Schema::Object
        add_field ::GraphQL::Types::Relay::NodeField
        add_field ::GraphQL::Types::Relay::NodesField

        field :talks, ::Jelly::GraphQL::Types::Talk.connection_type, null: false
        field :talk, ::Jelly::GraphQL::Types::Talk, null: true do
          argument :id, ID, required: true
        end

        def talks
          result = services[:query].call
          return unless result.success?

          result.value
        end

        def talk(id:)
          result = services[:find].call id: id
          return unless result.success?

          result.value
        end

        private

        def services
          {
            query: ::Jelly::Services::Talks::Query,
            find: ::Jelly::Services::Talks::Find
          }
        end
      end
    end
  end
end
