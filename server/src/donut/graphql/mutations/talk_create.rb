# frozen_string_literal: true

require_relative '../../services/talks/create'

module Donut
  module GraphQL
    module Mutations
      class TalkCreate < ::GraphQL::Schema::RelayClassicMutation
        argument :topic, String, required: true

        field :talk, ::Donut::GraphQL::Types::Talk, null: true
        field :errors, [String], null: false

        def resolve(params = {})
          result = services[:create].call params
          value = result.value
          return { talk: value, errors: [] } if result.success?

          { errors: value }
        end

        private

        def services
          {
            create: ::Donut::Services::Talks::Create
          }
        end
      end
    end
  end
end
