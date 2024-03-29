# frozen_string_literal: true

require 'securerandom'
require_relative '../base'
require_relative '../talks'
require_relative '../talks/find'

module Jelly
  module Services
    module ID
      class GlobalID < ::Jelly::Services::Base
        class InvalidNamespaceError < ::StandardError; end

        APP = :jelly

        FINDERS = {
          ::Jelly::Services::Talks::NAMESPACE => ::Jelly::Services::Talks::Find
        }.freeze

        class << self
          def generate(object)
            path = object.slice(:__namespace, :id).values.join('/')
            "gid://#{APP}/#{path}"
          end

          def locate(id)
            uri = URI.parse id
            nsp, id = uri.path.split('/')[1..-1]
            raise(InvalidNamespaceError, nsp) unless FINDERS.key?(nsp.to_sym)

            result = FINDERS[nsp.to_sym].call id
            return nil unless result.success?

            result.value
          end
        end
      end
    end
  end
end
