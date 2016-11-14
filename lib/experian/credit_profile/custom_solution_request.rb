require 'experian/credit_profile/request'

module Experian
  module CreditProfile
    class CustomSolutionRequest < Request
      #
      # CustomSolution is effectively CreditProfile
      # with some custom configured return attributes.
      #

      private

      def add_add_ons(xml)
        super do |xml|
          xml.tag!('CustomRRDashKeyword', Experian.test_mode ? 'XXP1' : 'DXP1')
        end
      end

      def add_risk_models(xml)
        nil
      end

      def experian_product
        'CustomSolution'
      end

      def arf_version
        '07'
      end
    end
  end
end
