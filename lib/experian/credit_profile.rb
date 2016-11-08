require 'experian/credit_profile/client'
require 'experian/credit_profile/request'
require 'experian/credit_profile/response'

module Experian
  module CreditProfile
    DB_HOST = 'CIS'
    DB_HOST_TEST = 'STAR'

    def self.db_host
      Experian.test_mode ? DB_HOST_TEST : DB_HOST
    end

    # convenience method
    def self.credit_profile(options = {})
      Client.new.credit_profile(options)
    end
  end
end
