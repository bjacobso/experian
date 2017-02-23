module Experian
  module PreciseId
    module ResponseHelpers
      def session_id
        hash_path(@response,"Products","PreciseIDServer","SessionID")
      end

      def fpd_score
        hash_path(@response,"Products","PreciseIDServer","Summary","FPDScore")
      end

      def score
        hash_path(@response,"Products","PreciseIDServer","Summary","PreciseIDScore")
      end

      def initial_decision
        hash_path(@response,"Products","PreciseIDServer","Summary","InitialResults","InitialDecision")
      end

      def final_decision
        hash_path(@response,"Products","PreciseIDServer","Summary","InitialResults","FinalDecision")
      end

      def accept_refer_code
        hash_path(@response,"Products","PreciseIDServer","KBAScore","ScoreSummary","AcceptReferCode")
      end

      def drivers_license_format_validation
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","ValidationSegment","DriversLicenseFormatValidation")
      end

      def driver_license_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","DriverLicenseResult")
      end

      def review_reference_id
        hash_path(@response, "Products","PreciseIDServer","Summary","ReviewReferenceID")
      end

      def validation_score
        hash_path(@response, "Products","PreciseIDServer","Summary","ValidationScore")
      end

      def verification_score
        hash_path(@response, "Products","PreciseIDServer","Summary","VerificationScore")
      end

      def address_verification_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","AddressVerificationResult")
      end

      def address_mismatch
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","AddressUnitMismatchResult")
      end

      def address_high_risk_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","AddressHighRiskResult")
      end

      def consumer_id_zip_code
        consumer_id_verification = hash_path(@response, "Products","PreciseIDServer","Checkpoint","ConsumerIDVerification")
        if consumer_id_verification.is_a? Array
          consumer_id_verification.first["ZipCode"]
        else
          consumer_id_verification["ZipCode"]
        end
      end

      def phone_high_risk_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","PhoneHighRiskResult")
      end

      def phone_verification_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","PhoneVerificationResult")
      end

      def date_of_birth_match
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults", "DateOfBirthMatch")
      end

      def ofac_validation_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","ValidationSegment","OFACValidationResult")
      end

      def ssn_result
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","SSNResult")
      end

      def ssn_code
        hash_path(@response,"Products","PreciseIDServer","GLBDetail","CheckpointSummary", "SSNCode")
      end
    end
  end
end
