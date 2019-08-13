# frozen_string_literal: true

require_relative '../../services/auth/sessions/create'
require_relative '../types/user'
require_relative '../types/token'

module Donut
  module GraphQL
    module Mutations
      class SessionCreate < ::GraphQL::Schema::RelayClassicMutation
        argument :google_id_token, String, required: true

        field :user, ::Donut::GraphQL::Types::User, null: true
        field :token, ::Donut::GraphQL::Types::Token, null: true
        field :errors, [String], null: false

        def resolve(google_id_token:)
          result = services[:create_session].call(
            google_id_token: google_id_token
          )

          val = result.value

          return { errors: val } if result.failure?

          { errors: [], user: val[:user], token: val[:token] }
        end

        private

        def services
          {
            create_session: ::Donut::Services::Auth::Sessions::Create
          }
        end
      end
    end
  end
end
