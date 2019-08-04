# frozen_string_literal: true

require 'active_support/core_ext/string'
require_relative './types/query'
require_relative './types/mutation'
require_relative '../services/id/global_id'

module Donut
  module GraphQL
    class Schema < ::GraphQL::Schema
      query ::Donut::GraphQL::Types::Query
      mutation ::Donut::GraphQL::Types::Mutation

      class << self
        def id_from_object(object, _type, _ctx)
          services[:gid].generate object
        end

        def object_from_id(id, _ctx)
          services[:gid].locate id
        end

        def resolve_type(_type, obj, _ctx)
          ::Donut::GraphQL::Types.const_get obj[:__namespace].classify.to_s
        end

        private

        def services
          {
            gid: ::Donut::Services::ID::GlobalID
          }
        end
      end
    end
  end
end
