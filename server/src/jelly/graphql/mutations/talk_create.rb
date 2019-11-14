# frozen_string_literal: true

require_relative '../../services/talks/create'

module Jelly
  module GraphQL
    module Mutations
      class TalkCreate < ::GraphQL::Schema::RelayClassicMutation
        argument :topic, String, required: true
        argument :description, String, required: true

        field :talk, ::Jelly::GraphQL::Types::Talk, null: true
        field :errors, [String], null: false

        def resolve(params = {})
          result = services[:create].call params.merge(
            submitted_by: context.dig(:current_user, :id)
          )

          value = result.value

          return { talk: value, errors: [] } if result.success?

          { errors: value }
        end

        private

        def services
          {
            create: ::Jelly::Services::Talks::Create
          }
        end
      end
    end
  end
end
