require 'experian/credit_profile'

module Experian
  module CreditProfile
    DB_HOST = 'CIS'
    DB_HOST_TEST = 'STAR'

    def self.db_host
      Experian.test_mode? DB_HOST_TEST : DB_HOST
    end
  end
end
