# frozen_string_literal: true

require_relative '../base'
require_relative './find'

module Jelly
  module Services
    module Users
      class Current < ::Jelly::Services::Base
        def call(request)
          header = request.env['HTTP_AUTHORIZATION']
          return unless header.present?

          type, token = header.split ' '
          return unless type == 'Bearer' && token.present?

          services[:find].call(auth_token: token).value
        end

        private

        def services
          {
            find: ::Jelly::Services::Users::Find
          }
        end
      end
    end
  end
end
