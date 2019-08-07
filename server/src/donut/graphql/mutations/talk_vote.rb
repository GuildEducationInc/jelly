# frozen_string_literal: true

require_relative '../../services/talks/vote'
require_relative '../types/direction'

module Donut
  module GraphQL
    module Mutations
      class TalkVote < ::GraphQL::Schema::RelayClassicMutation
        argument :id, ID, required: true
        argument :direction, ::Donut::GraphQL::Types::Direction, required: true

        field :talk, ::Donut::GraphQL::Types::Talk, null: true
        field :errors, [String], null: false

        def resolve(id:, direction:)
          result = services[:vote].call(
            id: id,
            direction: direction,
            voter_id: context.dig(:current_user, :id)
          )

          value = result.value

          return { talk: value, errors: [] } if result.success?

          { errors: value }
        end

        private

        def services
          {
            vote: ::Donut::Services::Talks::Vote
          }
        end
      end
    end
  end
end
