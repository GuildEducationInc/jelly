# frozen_string_literal: true

require_relative '../base'

module Jelly
  module Services
    module Talks
      class Vote < ::Jelly::Services::Base
        def call(id:, direction:, voter_id:)
          success vote!(id, direction, voter_id)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def vote!(id, direction, voter_id)
          raw = lua.talks.vote [NAMESPACE, id, voter_id], [direction]
          Talks.build(*raw)
        end
      end
    end
  end
end
