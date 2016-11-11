module Experian
  module CreditProfile
    class Client < Experian::Client

      def credit_profile(options = {})
        submit_request(Request.new(options))
      end

      def custom_solution(options = {})
        submit_request(CustomSolutionRequest.new(options))
      end

      private

      def submit_request(request)
        puts '>>>>>>>>>>>>>>>>>>>>'
        puts "#{request.inspect}"
        puts '<<<<<<<<<<<<<<<<<<<<'
        raw_response = super
        response = Response.new(raw_response.body)
        check_response(response,raw_response)
        # parse response here to make indicators verbose
        # response = response.add_node_descriptions
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
