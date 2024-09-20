# frozen_string_literal: true

require 'English'

module Pronto
  class Eslinter < Runner
    class Output
      extend Forwardable

      attr_reader :data, :patch, :eslinter

      def_delegator :eslinter, :eslint_config
      def_delegator :eslinter, :logger

      def initialize(data, patch, eslinter)
        @data = data.first
        @patch = patch
        @eslinter = eslinter
      end

      def file_path
        data[:filePath]
      end

      def messages
        @messages ||= @data[:messages].filter_map do |message|
          Offense.new(message, self).message
        end
      end

      def suppressed_messages
        data[:suppressedMessages]
      end

      def error_count
        data[:errorCount]
      end

      def fatal_error_count
        data[:fatalErrorCount]
      end

      def warning_count
        data[:warningCount]
      end

      def fixable_error_count
        data[:fixableErrorCount]
      end

      def fixable_warning_count
        data[:fixableWarningCount]
      end

      def source
        data[:source]
      end

      def used_deprecated_rules
        data[:usedDeprecatedRules]
      end
    end
  end
end
