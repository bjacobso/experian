require 'rexml/document'

module Experian
  class Response

      attr_reader :xml, :response

      def initialize(xml)
        @xml = xml
        @response = parse_xml_response
      end

      def host_response
        @response["HostResponse"]
      end

      def completion_code
        @response["CompletionCode"]
      end

      def completion_message
        Experian::COMPLETION_CODES[completion_code]
      end

      def transaction_id
        @response["TransactionId"]
      end

      def success?
        completion_code == "0000"
      end

      def error?
        completion_code != "0000"
      end

      def error_message
        @response["ErrorMessage"]
      end

      def error_tag
        @response["ErrorTag"]
      end

      def error_code?
        error_node.present?
      end

      def error_code
        error_code_response['ErrorCode'].to_i
      end

      def error_code_response
        parse_element(error_node) if error_code?
      end

      def error_code_message
        Experian::ERROR_CODES[error_code]
      end

      def error_action_indicator_message
        if error_code_response
          error_code_response["ActionIndicator"]
        else
          Experian::ERROR_ACTION_INDICATORS[error_action_indicator]
        end
      end

      def statement?
        statement_node.present?
      end

      def statement_response
        parse_element(statement_node) if statement?
      end

      def statement_code
        statement_response["Type"]
      end

      def statement_message
        statement_response["StatementText"]["MessageText"]
      end

      private

      def xml_doc
        REXML::Document.new(@xml)
      end

      def error_node
        REXML::XPath.match(xml_doc, "//Error").last
      end

      def root_node
        REXML::XPath.first(xml_doc, "//NetConnectResponse")
      end

      def statement_node
        REXML::XPath.first(xml_doc, "//Statement")
      end

      def parse_xml_response
        if root_node
          parse_element(root_node)
        else
          raise Experian::ClientError, "Invalid xml response from Experian"
        end
      end

      # parse xml node elements recursively into hash
      def parse_element(node)
        if node.has_elements?
          response = {}
          node.elements.each do |e|
            key = e.name
            value = parse_element(e)
            if response.has_key?(key)
              if response[key].is_a?(Array)
                response[key].push(value)
              else
                response[key] = [response[key], value]
              end
            else
              response[key] = parse_element(e)
            end
          end
        else
          response =
            if node.text.blank?
              node.attributes.get_attribute("code").try(:value).try(:strip).presence
            else
              node.text.strip
            end
        end
        response
      end

  end
end
