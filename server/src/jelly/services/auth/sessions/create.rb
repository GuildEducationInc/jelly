# frozen_string_literal: true

require 'securerandom'
require_relative '../../base'
require_relative '../google/verify'
require_relative '../../users/upsert'

module Jelly
  module Services
    module Auth
      module Sessions
        class Create < ::Jelly::Services::Base
          def call(google_id_token:)
            google_result = services[:google_verify].call google_id_token
            return failure(google_result.value) if google_result.failure?

            upsert = services[:upsert_user].call(
              google_profile: google_result.value
            )

            return failure(upsert.value) if upsert.failure?

            user = upsert.value

            success user: user, token: {
              access_token: upsert_token(user[:id]),
              token_type: 'Bearer'
            }
          rescue StandardError => e
            failure [e.message]
          end

          private

          def upsert_token(user_id)
            if redis.exists("auth:user:#{user_id}")
              return redis.get("auth:user:#{user_id}")
            end

            SecureRandom.uuid.tap do |token|
              redis.multi do |txn|
                txn.set "auth:user:#{user_id}", token
                txn.set "auth:token:#{token}", user_id
              end
            end
          end

          def services
            {
              google_verify: ::Jelly::Services::Auth::Google::Verify,
              upsert_user: ::Jelly::Services::Users::Upsert
            }
          end
        end
      end
    end
  end
end
