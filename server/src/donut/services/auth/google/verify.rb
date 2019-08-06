# frozen_string_literal: true

require 'active_support/core_ext/hash'
require_relative '../../base'

module Donut
  module Services
    module Auth
      module Google
        class Verify < ::Donut::Services::Base
          class InvalidDomainError < StandardError; end

          CLIENT_ID = '715743042136-s85bpps3q5jhhv92oe1f5vu8ona3r35n.apps.googleusercontent.com'
          DOMAIN = 'guildeducation.com'

          def call(token)
            validator = GoogleIDToken::Validator.new
            payload = validator.check(token, CLIENT_ID).with_indifferent_access
            domain = payload[:hd]
            raise(InvalidDomainError, domain) unless domain == DOMAIN

            success payload
          rescue GoogleIDToken::ValidationError => e
            failure [e.message]
          end
        end
      end
    end
  end
end
