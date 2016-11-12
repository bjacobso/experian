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
        self.xml = doc.to_s
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
