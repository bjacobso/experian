module Experian
  module PreciseId
    class Response < Experian::Response

      def success?
        super && has_precise_id_section? && !error?
      end

      def error?
        super || !has_precise_id_section? || has_error_section?
      end

      def error_code
        has_error_section? ? error_section["ErrorCode"] : nil
      end

      def error_message
        if has_error_section?
          error_message = error_section["ErrorDescription"]
        else
          error_message = nil
        end

        super || error_message
      end

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

      def driver_license_format_validation
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
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","ConsumerIDVerification").first["ZipCode"]
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
      def ssn_issue_result_code
        hash_path(@response, "Products","PreciseIDServer","Checkpoint","GeneralResults","SSNIssueResultCode")
      end

      def questions
        questions = hash_path(@response,"Products","PreciseIDServer","KBA","QuestionSet")
        if questions
          questions.collect do |question|
            {
              :type => question["QuestionType"].to_i,
              :text => question["QuestionText"],
              :choices => question["QuestionSelect"]["QuestionChoice"]
            }
          end
        else
          []
        end
      end

      private

      def has_precise_id_section?
        !!precise_id_server_section
      end

      def precise_id_server_section
        hash_path(@response,"Products","PreciseIDServer")
      end

      def has_error_section?
        !!error_section
      end

      def error_section
        hash_path(@response,"Products","PreciseIDServer","Error")
      end

      def hash_path(hash, *path)
        field = path[0]
        if path.length == 1
          hash[field]
        else
          if hash[field]
            hash_path(hash[field], *path[1..-1])
          else
            nil
          end
        end
      end
    end
  end
end
