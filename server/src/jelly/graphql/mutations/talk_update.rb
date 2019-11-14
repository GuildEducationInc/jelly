# frozen_string_literal: true

require_relative '../../services/talks/update'

module Jelly
  module GraphQL
    module Mutations
      class TalkUpdate < ::GraphQL::Schema::RelayClassicMutation
        argument :id, ID, required: true
        argument :topic, String, required: false
        argument :description, String, required: false

        field :talk, ::Jelly::GraphQL::Types::Talk, null: true
        field :errors, [String], null: false

        def resolve(params = {})
          result = services[:update].call params
          value = result.value
          return { talk: value, errors: [] } if result.success?

          { errors: value }
        end

        private

        def services
          {
            update: ::Jelly::Services::Talks::Update
          }
        end
      end
    end
  end
end
