# frozen_string_literal: true

module Pronto
  class Eslinter < Runner
    class Suggestion
      extend Forwardable

      attr_reader :offense

      def_delegators :offense, :eslint_config, :eslint_output, :line, :fix, :column, :end_line, :end_column
      def_delegators :eslint_output, :source

      def initialize(offense)
        @offense = offense
      end

      def suggest
        return unless enabled? && suggestable?

        "\n\n```suggestion\n#{fixed_line}#{new_line_maybe}```"
      end

      private

      def suggestable?
        enabled? && !fix.nil?
      end

      def fixed_line
        impacted_replace_lines = fix[:text].split("\n").length
        "#{left}#{fix[:text]}#{right}".split("\n")[line - 1...line - 1 + impacted_replace_lines].join("\n")
      end

      def left
        source.slice(0, fix[:range][0])
      end

      def right
        source.slice(fix[:range][1]..)
      end

      def new_line_maybe
        "\n" unless fixed_line.end_with?("\n")
      end

      def enabled?
        eslint_config['suggestions'] || false
      end
    end
  end
end
