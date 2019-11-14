# frozen_string_literal: true

require 'securerandom'
require 'active_support/core_ext/hash'
require_relative '../base'
require_relative '../users'

module Jelly
  module Services
    module Users
      class Upsert < ::Jelly::Services::Base
        def call(google_profile:)
          user_id = redis.get "google_ids_to_user_ids:#{google_profile[:sub]}"

          user = {
            google_profile: google_profile,
            __namespace: NAMESPACE
          }

          if user_id
            redis.set "#{NAMESPACE}:#{user_id}", user.merge(id: user_id).to_json
            return success(load_user(user_id))
          end

          uuid = SecureRandom.uuid

          redis.multi do |txn|
            txn.sadd "#{NAMESPACE}:all", uuid
            txn.set "#{NAMESPACE}:#{uuid}", user.merge(id: uuid).to_json
            txn.set "google_ids_to_user_ids:#{google_profile[:sub]}", uuid
          end

          success load_user(uuid)
        rescue StandardError => e
          failure [e.message]
        end

        private

        def load_user(id)
          JSON.parse(redis.get("#{NAMESPACE}:#{id}")).with_indifferent_access
        end
      end
    end
  end
end
