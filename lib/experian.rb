require "excon"
require "builder"
require "experian/version"
require "experian/constants"
require "experian/error"
require "experian/client"
require "experian/request"
require "experian/response"
require "experian/connect_check"
require "experian/precise_id"
require "experian/business_iq"
require "experian/password_reset"
require "experian/credit_profile"

module Experian
  include Experian::Constants

  class << self

    attr_accessor :eai, :preamble, :op_initials, :subcode, :user, :password,
                  :vendor_number, :risk_models, :reference_number, :account_type_code,
                  :account_type_terms, :url, :test_url
    attr_accessor :test_mode, :proxy, :logger

    def configure
      Experian.test_url = Experian::PRECISE_ID_TEST_URL
      Experian.url = Experian::PRECISE_ID_URL
      yield self
    end

    def test_mode?
      !!test_mode
    end

    def ecals_uri
      uri = URI(Experian::LOOKUP_SERVLET_URL)
      uri.query = URI.encode_www_form(
        'lookupServiceName' => Experian::LOOKUP_SERVICE_NAME,
        'lookupServiceVersion' => Experian::LOOKUP_SERVICE_VERSION,
        'serviceName' => service_name,
        'serviceVersion' => Experian::SERVICE_VERSION,
        'responseType' => 'text/plain'
      )
      uri
    end

    def net_connect_uri
      perform_ecals_lookup if ecals_lookup_required?
      add_credentials(@net_connect_uri)
    end

    def precise_id_uri
      uri = URI.parse(test_mode? ? Experian.test_url : Experian.url)
      add_credentials(uri)
    end

    def credit_profile_uri
      perform_ecals_lookup if ecals_lookup_required?
      # add_credentials(uri) # credentials are passed in encrypted header
      @net_connect_uri
    end

    def add_credentials(uri)
      uri.tap do |u|
        u.user = Experian.user
        u.password = Experian.password
      end
    end

    def perform_ecals_lookup
      @net_connect_uri = URI.parse(Excon.get(ecals_uri.to_s).body.strip)
      @ecals_last_update = Time.now
    rescue Excon::Errors::SocketError => e
      raise Experian::ClientError, "Could not connect to Experian: #{e.message}"
    end

    def ecals_lookup_required?
      @net_connect_uri.nil? || @ecals_last_update.nil? || Time.now - @ecals_last_update > Experian::ECALS_TIMEOUT
    end

    def service_name
      test_mode? ? Experian::SERVICE_NAME_TEST : Experian::SERVICE_NAME
    end

  end
end
