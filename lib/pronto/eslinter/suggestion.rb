# frozen_string_literal: true

module Pronto
  class Eslinter < Runner
    class Suggestion
      extend Forwardable

      attr_reader :offense, :fix

      def_delegators :offense, :eslint_config, :eslint_output, :line, :column, :end_line, :end_column, :patch
      def_delegators :eslint_output, :source

      def initialize(offense)
        @offense = offense
        @fix = offense.raw_offense[:fix]
      end

      def suggest
        return {} unless suggestable?

        {
          text: "\n\n```suggestion\n#{replaced_line}#{new_line_maybe}```",
          line: line_number_after_fix
        }
      end

      private

      def suggestable?
        enabled? && !fix.nil?
      end

      def replaced_line
        fixed_lines[line_number_after_fix - 1...line_number_after_fix - 1 + fix_line_count].join("\n")
      end

      def line_number_after_fix
        if fixed_lines.size < source.split("\n").size
          line - (end_line - line)
        else
          line
        end
      end

      def fixed_lines
        "#{left}#{fix[:text]}#{right}".split("\n")
      end

      def fix_line_count
        fix[:text].split("\n").length
      end

      def left
        source.slice(0, fix[:range][0])
      end

      def right
        source.slice(fix[:range][1]..)
      end

      def new_line_maybe
        "\n" unless replaced_line.end_with?("\n")
      end

      def enabled?
        eslint_config['suggestions'] || false
      end
    end
  end
end
