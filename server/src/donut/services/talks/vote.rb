# frozen_string_literal: true

require_relative '../base'

module Donut
  module Services
    module Talks
      class Vote < ::Donut::Services::Base
        SCRIPT = File.read File.join(__dir__, 'vote.lua')

        def call(id:, direction:, voter_id:)
          success vote!(id, direction, voter_id)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def vote!(id, direction, voter_id)
          raw, score, voter_ids, scheduled_for = redis.eval(
            SCRIPT,
            [NAMESPACE, id, voter_id],
            [direction]
          )

          obj = JSON.parse(raw).with_indifferent_access

          obj.merge(
            votes_count: score,
            voter_ids: voter_ids,
            scheduled_for: scheduled_for
          )
        end
      end
    end
  end
end
