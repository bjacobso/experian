module Experian
  module PreciseId
    class PrimaryRequest < Request

      def add_request_content(xml)
        xml.tag!('XMLVersion', "5.0")
        add_subscriber(xml)
        add_applicant(xml)
        xml.tag!('Verbose', "Y") if @options[:verbose]
        add_vendor(xml)
        add_options(xml)
        xml.tag!('IPAddress', @options[:ip_address]) if @options[:ip_address]
      end

      def headers
        super
      end

      private

      def add_subscriber(xml)
        xml.tag!('Subscriber') do
          xml.tag!('Preamble', Experian.preamble)
          xml.tag!('OpInitials', Experian.op_initials)
          xml.tag!('SubCode', Experian.subcode)
        end
      end

      def add_applicant(xml)
        xml.tag!('PrimaryApplicant') do
          xml.tag!('Name') do
            xml.tag!('Surname', @options[:last_name])
            xml.tag!('First', @options[:first_name])
          end
          xml.tag!('SSN', @options[:ssn]) if @options[:ssn]
          add_current_address(xml)
          add_driver_license(xml)
          add_phone_number(xml)
          xml.tag!('DOB', @options[:dob]) if @options[:dob]
          xml.tag!('EmailAddress', @options[:email]) if @options[:email]
        end
      end

      def add_current_address(xml)
        xml.tag!('CurrentAddress') do
          xml.tag!('Street', @options[:street])
          xml.tag!('City', @options[:city])
          xml.tag!('State', @options[:state])
          xml.tag!('Zip', @options[:zip])
        end if @options[:zip]
      end

      def add_phone_number(xml)
        xml.tag!('Phone') do
          xml.tag!('Number', @options[:phone])
          xml.tag!('Type', @options[:phone_type] || "C") # default to Cellular
        end if @options[:phone]
      end

      def add_driver_license(xml)
        xml.tag!('DriverLicense') do
          xml.tag!('State', @options[:dl_state])
          xml.tag!('Number', @options[:dl_number])
        end if @options[:dl_number] && @options[:dl_state]
      end

      def add_vendor(xml)
        xml.tag!('Vendor') do
          xml.tag!('VendorNumber', Experian.vendor_number)
        end
      end

      def add_options(xml)
        xml.tag!('Options') do
          xml.tag!('FreezeKeyPIN', @options[:freeze_key_pin]) if @options[:freeze_key_pin]
          xml.tag!('PreciseIDType', "11")
          xml.tag!('ReferenceNumber', "XML PROD OP 19") if @options[:reference_number]
          xml.tag!('DetailRequest', "D") if @options[:detail_request]
          xml.tag!('InquiryChannel', "INTE") if @options[:inquiry_channel]
        end
      end
    end
  end
end
