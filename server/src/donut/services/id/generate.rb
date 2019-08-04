# frozen_string_literal: true

require 'securerandom'
require_relative '../base'

module Donut
  module Services
    module ID
      class Generate < ::Donut::Services::Base
        def call
          success SecureRandom.uuid
        end
      end
    end
  end
end
