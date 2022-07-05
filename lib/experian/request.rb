module Experian
  class Request

    attr_reader :xml
    attr_reader :mocked_endpoint

    def initialize(options = {})
      @options = options
      @xml = build_request
    end

    def which_mocking_key
      @options[:mocking] ? @options[:mocking]["key"] : nil
    end

    def mocking
      @options[:mocking] ? @options[:mocking] : {"enabled" => false}
    end

    def mocked_endpoint
      mocking["enabled"] && mocking[which_mocking_key]["endpoint"].length > 0 ? mocking[which_mocking_key]["endpoint"] : ""
    end

    def build_request
      xml = Builder::XmlMarkup.new(:indent => 2)
      xml.instruct!(:xml, :version => '1.0', :encoding => 'utf-8')
      xml.tag!("NetConnectRequest",
        'xmlns' => Experian::XML_NAMESPACE,
        'xmlns:xsi' => Experian::XML_SCHEMA_INSTANCE,
        'xsi:schemaLocation' => Experian::XML_SCHEMA_LOCATION) do
          yield xml if block_given?
      end
    end

    def body
      @body ||= URI.encode_www_form('NETCONNECT_TRANSACTION' => xml)
    end

    def headers
      {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Content-Length" => "#{body.length}"
      }
    end

  end
end
