# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../base'

module Jelly
  module Services
    module Users
      class Find < ::Jelly::Services::Base
        def call(auth_token:)
          id = redis.get "auth:token:#{auth_token}"
          return success(nil) unless id && redis.exists(key(id))

          raw = redis.get key(id)
          obj = JSON.parse(raw).with_indifferent_access
          success obj
        end

        private

        def key(id)
          "#{NAMESPACE}:#{id}"
        end
      end
    end
  end
end
