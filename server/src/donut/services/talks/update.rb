# frozen_string_literal: true

require_relative '../base'

module Donut
  module Services
    module Talks
      class Update < ::Donut::Services::Base
        def call(params = {})
          success update_talk!(params)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def update_talk!(params)
          id = params.delete :id
          raise "talk not found: #{id}" unless redis.exists(key(id))

          prev = redis.get key(id)
          obj = JSON.parse(prev).with_indifferent_access
          updated = obj.merge params.compact
          redis.set key(id).to_s, updated.to_json
          votes = redis.zscore "#{NAMESPACE}:all", id
          voter_ids = redis.smembers "#{key(id)}:voter_ids"

          updated.merge votes_count: votes, voter_ids: voter_ids
        end

        def key(id)
          "#{NAMESPACE}:#{id}"
        end
      end
    end
  end
end
