require 'nokogiri'

module Experian
  module CreditProfile
    class Response < Experian::Response
      include Experian::CreditProfile::IndicatorCodes
      include Experian::Constants

      attr_writer :xml

      def add_node_descriptions
        doc = Nokogiri::XML(xml)
        doc.remove_namespaces!
        update_fraud_indicators(doc)
        update_score_factors(doc)
        parse_ofac_and_mla(doc)
        parse_file_hit(doc)
        self.xml = doc.to_s
      end

      def parse_file_hit(doc)
        doc.xpath('//InformationalMessage').each do |message|
          if message.at_xpath('./MessageNumber').content.to_i == NO_RECORD_CODE
            message['type'] = 'NO_RECORD'
          end
        end
      end

      def parse_ofac_and_mla(doc)
        doc.xpath('//InformationalMessage').each do |message|
          next if message.at_xpath('./MessageNumber').content.to_i != OFAC_MLA_INDICATOR
          message_text = message.at_xpath('./MessageText')
          code = message_text.content.match(/\d{4}/)[0].to_i # pull out 4 digit indicator code
          message_text['code'] = code
          if MLA_CODES.include? code
            message['type'] = 'MLA'
          elsif OFAC_CODES.include? code
            message['type'] = 'OFAC'
            hit = code.to_i == OFAC_HIT ? 'Hit' : 'NoHit'
            message << "<OFACHit>#{hit}</OFACHit>"
          end
        end
      end

      def update_fraud_indicators(doc)
        doc.xpath('//FraudServices/Indicator').each do |indicator|
          code = indicator.content.strip
          unless code.empty?
            indicator['code'] = code
            indicator.content = FRAUD_INDICATORS[code.to_i]
          end
        end
      end

      def update_score_factors(doc)
        doc.xpath('//RiskModel').each do |risk_model|
          code = risk_model.at_xpath('./ModelIndicator')['code']
          if code == 'V3'
            risk_model.children.each do |node|
              if node.name.match(/ScoreFactorCode.+/)
                code = node.content.strip
                node.name = 'ScoreFactor'
                node['code'] = code
                node.content = VANTAGE3_SCORE_FACTORS[code.to_i]
              end
            end
          elsif code == 'II'
            risk_model.children.each do |node|
              # This might be overkill, but IncomeInsight doesn't return any ScoreFactors
              if node.name.match(/ScoreFactorCode.+/)
                node.remove
              end
            end
          end
        end
      end

    end
  end
end
