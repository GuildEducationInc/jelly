# frozen_string_literal: true

require_relative '../base'

module Donut
  module Services
    module Talks
      class Vote < ::Donut::Services::Base
        SCRIPT = File.read File.join(__dir__, 'vote.lua')

        def call(id:, direction:)
          success vote!(id, direction)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def vote!(id, direction)
          raw, score = redis.eval SCRIPT, [NAMESPACE, id], [direction]
          obj = JSON.parse(raw).with_indifferent_access
          obj.merge votes: score
        end
      end
    end
  end
end
