module Experian
  module PreciseId
    class Request < Experian::Request
      def build_request
        super do |xml|
          xml.tag!('EAI', Experian.eai)
          xml.tag!('DBHost', PreciseId.db_host)
          add_reference_id(xml)
          xml.tag!('Request') do
            xml.tag!('Products') do
              xml.tag!('PreciseIDServer') do
                add_request_content(xml)
              end
            end
          end
        end
      end

      def add_reference_id(xml)
        xml.tag!('ReferenceId', @options[:reference_id]) if @options[:reference_id]
      end

      def add_request_content(xml)
        raise "sub classes must override this method"
      end

      def mocking_headers
        if @options[:mocking] && @options[:mocking]["precise_id"]["enabled"]
          @options[:mocking]["precise_id"]["headers"]
        else
          {}
        end
      end

      def headers
        headers = super
        headers = headers.merge!(mocking_headers)
        headers
      end
    end
  end
end
