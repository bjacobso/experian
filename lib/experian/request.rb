module Experian
  class Request

    attr_reader :xml
    attr_reader :mocking 
    attr_reader :mocked_uri

    def initialize(options = {})
      @options = options
      @xml = build_request
      @isMocked = options["mocking"]["enabled"]
    end

    def mocked_uri(uri)
      @isMocked ? uri << @options.mocking["uri"] : uri
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
