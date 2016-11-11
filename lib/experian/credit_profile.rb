require 'experian/credit_profile/client'
require 'experian/credit_profile/request'
require 'experian/credit_profile/custom_solution_request'
require 'experian/credit_profile/response'

module Experian
  module CreditProfile
    DB_HOST = 'CIS'
    DB_HOST_TEST = 'STAR'

    class << self
      def db_host
        Experian.test_mode ? DB_HOST_TEST : DB_HOST
      end

      # convenience method
      def credit_profile(options = {})
        Client.new.credit_profile(options)
      end

      def custom_solution(options = {})
        Client.new.custom_solution(options)
      end
    end
  end
end
