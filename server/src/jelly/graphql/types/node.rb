# frozen_string_literal: true

require_relative '../../services/id/global_id'

module Jelly
  module GraphQL
    module Types
      class Node < ::GraphQL::Schema::Object
        global_id_field :gid
        implements ::GraphQL::Relay::Node.interface
        field :id, ::GraphQL::Types::ID, null: false

        def gid
          services[:gid].generate object
        end

        private

        def services
          {
            gid: ::Jelly::Services::ID::GlobalID
          }
        end
      end
    end
  end
end
