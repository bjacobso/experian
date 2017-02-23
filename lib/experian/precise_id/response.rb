require_relative "response_helpers"

module Experian
  module PreciseId
    class Response < Experian::Response
      include Experian::PreciseId::ResponseHelpers

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
