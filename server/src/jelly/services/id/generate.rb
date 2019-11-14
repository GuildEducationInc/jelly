# frozen_string_literal: true

require 'securerandom'
require_relative '../base'

module Jelly
  module Services
    module ID
      class Generate < ::Jelly::Services::Base
        def call
          success SecureRandom.uuid
        end
      end
    end
  end
end
