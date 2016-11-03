module Experian
  module CreditProfile
    class Client < Experian::Client

      def credit_pull(options = {})
        submit_request(Request.new(options))
      end

      private

      def submit_request(request)
        raw_response = super
        response = Response.new(raw_response.body)
        check_response(response,raw_response)
        [request,response]
      end

      def check_response(response,raw_response)
        if Experian.logger && response.error? && (response.error_code.nil? && response.error_message.nil?)
          Experian.logger.debug "Unknown Experian Error Detected, Raw response: #{raw_response.inspect}"
        end
      end

      def request_uri
        Experian.credit_profile_uri
      end
    end
  end
end
