require 'base64'

module Experian
  module CreditProfile
    class Request < Experian::Request

      def build_request
        super do |xml|
          xml.tag!('EAI', Experian.eai)
          xml.tag!('DBHost', CreditProfile.db_host)
          add_reference_id(xml)
          xml.tag!('Request',
            'xmlns' => Experian::Constants::XML_REQUEST_NAMESPACE,
            'version' => Experian::Constants::WEB_DELIVERY_VERSION) do
              xml.tag!('Products') do
                xml.tag!('CreditProfile') do
                  add_request_content(xml)
                end
              end
          end
        end
      end

      def headers
        encoded_credentials = Base64.urlsafe_encode64("#{Experian.user}:#{Experian.password}")
        super.merge!({ 'Authorization' => "BASIC #{encoded_credentials}"})
      end

      def add_reference_id(xml)
        xml.tag!('ReferenceId', @options[:reference_id]) if @options[:reference_id]
      end

      def add_request_content(xml)
        add_subscriber(xml)
        add_primary_applicant(xml)
        add_add_ons(xml)
        add_xml_options(xml)
        add_vendor(xml)
        add_options(xml)
      end

      private

      def add_subscriber(xml)
        xml.tag!('Subscriber') do
          xml.tag!('Preamble', Experian.preamble)
          xml.tag!('OpInitials', Experian.op_initials)
          xml.tag!('SubCode', Experian.subcode)
        end
      end

      def add_primary_applicant(xml)
        xml.tag!('PrimaryApplicant') do
          xml.tag!('Name') do
            xml.tag!('Surname', @options[:last_name])
            xml.tag!('First', @options[:first_name])
          end
          xml.tag!('SSN', @options[:ssn])
          add_current_address(xml)
          add_employment(xml)
          add_phone(xml)

          xml.tag!('DOB', @options[:dob]) if @options[:dob]
          xml.tag!('FileUnfreezePIN', @options[:file_unfreeze_pin]) if @options[:file_unfreeze_pin]
        end
      end

      def add_employment(xml)
        # if this <Employment /> tag is empty do things blow up?
        if @options[:employment]
          employment = @options[:employment]
          xml.tag!('Employment') do
            xml.tag!('Company', employment[:company]) if employment[:company]
            xml.tag!('Address', employment[:address]) if employment[:address]
            xml.tag!('City', employment[:city]) if employment[:city]
            xml.tag!('City', employment[:city]) if employment[:city]
            xml.tag!('State', employment[:state]) if employment[:state]
            xml.tag!('Zip', employment[:zip]) if employment[:zip]
          end
        end
      end

      def add_current_address(xml)
        xml.tag!('CurrentAddress') do
          xml.tag!('Street', @options[:street])
          xml.tag!('City', @options[:city])
          xml.tag!('State', @options[:state])
          xml.tag!('Zip', @options[:zip])
        end
      end

      def add_phone(xml)
        if @options[:phone]
          phone = @options[:phone]
          xml.tag!('Phone') do
            xml.tag!('Number', phone[:number]) if phone[:number] # max length 13 chars
            # type should be C = Cellular, R = Residential, B = Business, etc.
            xml.tag!('Type', phone[:type]) if phone[:type]
          end
        end
      end

      # def secondary_applicant(xml)
      # end

      def add_add_ons(xml)
        xml.tag!('AddOns') do
          xml.tag!('FraudShield', 'Y')
          add_risk_models(xml)
          add_demographic_band(xml)
          add_credit_score_exception_notice(xml)
        end
      end

      def add_risk_models(xml)
        xml.tag!('RiskModels') do
          xml.tag!('VantageScore3', 'Y')
        end
      end

      def add_demographic_band(xml)
      end

      def add_credit_score_exception_notice(xml)
      end


      def add_vendor(xml)
        xml.tag!('Vendor') do
          xml.tag!('VendorNumber', Experian.vendor_number)
        end
      end

      def add_options(xml)
        xml.tag!('Options') do
          xml.tag!('ReferenceNumber', 'Y')
          xml.tag!('OFAC', 'Y')
          xml.tag!('OFACMSG', 'Y')
        end
      end

      def add_xml_options(xml)
        xml.tag!('OutputType') do
          xml.tag!('XML') do
            xml.tag!('ARFVersion', Experian::Constants::ARF_VERSION)
            xml.tag!('Verbose', 'Y')
            xml.tag!('Y2K', 'Y')
            xml.tag!('Segment130', 'Y') # todo --> what is Segment130?
          end
        end
      end
    end
  end
end
