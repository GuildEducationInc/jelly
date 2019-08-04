# frozen_string_literal: true

require_relative '../base'
require_relative '../id/generate'

module Donut
  module Services
    module Talks
      class Create < ::Donut::Services::Base
        def call(params = {})
          success create_talk!(params)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def create_talk!(topic:)
          id = services[:generate_id].call.value
          args = { topic: topic, id: id, __namespace: NAMESPACE, votes: 0.0 }

          redis.multi do |txn|
            txn.set "#{NAMESPACE}:#{id}", args.to_json
            txn.zadd "#{NAMESPACE}:all", 0.0, id
          end

          args
        end

        def services
          {
            generate_id: ::Donut::Services::ID::Generate
          }
        end
      end
    end
  end
end
