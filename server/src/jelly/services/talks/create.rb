# frozen_string_literal: true

require_relative '../base'
require_relative '../id/generate'

module Jelly
  module Services
    module Talks
      class Create < ::Jelly::Services::Base
        def call(params = {})
          success create_talk!(params)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def create_talk!(topic:, description:, submitted_by:)
          id = services[:generate_id].call.value
          votes = 0.0

          args = {
            topic: topic,
            description: description,
            submitted_by: submitted_by,
            id: id,
            __namespace: NAMESPACE
          }

          redis.pipelined do |txn|
            txn.set "#{NAMESPACE}:#{id}", args.to_json
            txn.zadd "#{NAMESPACE}:all", votes, id
          end

          Talks.build args
        end

        def services
          {
            generate_id: ::Jelly::Services::ID::Generate
          }
        end
      end
    end
  end
end
