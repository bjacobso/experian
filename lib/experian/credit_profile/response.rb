require 'nokogiri'

module Experian
  module CreditProfile
    class Response < Experian::Response
      include Experian::CreditProfile::IndicatorCodes

      def add_node_descriptions
        begin
          doc = Nokogiri::XML(xml)
          # parse through the FraudServices and VantageScore3 nodes
          # to make Indicators and ScoreFactors more verbose
          doc.xpath('./FraudServices/Indicator').each do |indicator|
            unless indicator.value.nil?
              # give node a 'code' attribute and content of the corresponding indicator message.
            end
          end
        rescue => e
          puts "Something Broke :( \n#{e.message}"
        end
      end

    end
  end
end
