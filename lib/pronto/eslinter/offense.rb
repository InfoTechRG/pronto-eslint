# frozen_string_literal: true

require 'English'

module Pronto
  class Eslinter < Runner
    class Offense
      extend Forwardable

      attr_reader(
        :raw_offense,
        :rule_id,
        :severity,
        :offense_message,
        :line,
        :column,
        :node_type,
        :message_id,
        :end_line,
        :end_column,
        :eslint_output
      )

      def_delegators :eslint_output, :eslint_config, :patch, :logger

      def initialize(offense, eslint_output)
        map_offense(offense)
        @raw_offense = offense
        @eslint_output = eslint_output
      end

      def message
        return log_fatal_error if fatal?

        Message.new(file_path, patch_line, level, message_text, nil, Pronto::Eslinter)
      end

      private

      def map_offense(offense)
        @fatal = offense[:fatal]
        @rule_id = offense[:ruleId]
        @severity = offense[:severity]
        @offense_message = offense[:message]
        @line = offense[:line]
        @column = offense[:column]
        @node_type = offense[:nodeType]
        @message_id = offense[:messageId]
        @end_line = offense[:endLine]
        @end_column = offense[:endColumn]
      end

      def message_text
        "#{offense_message}#{rule}#{suggestion[:text]}"
      end

      def rule
        return if rule_id.nil?

        " eslint([#{rule_id}](https://eslint.org/docs/latest/rules/#{rule_id}))"
      end

      def suggestion
        @suggestion ||= Suggestion.new(self).suggest
      end

      def patch_line
        @patch_line ||= patch.added_lines.find { |l| l.new_lineno == (suggestion[:line] || line) }
      end

      def file_path
        patch_line.patch.delta.new_file[:path] if patch_line
      end

      def level
        case severity
        when 1 then :warning
        when 2 then :error
        else :info
        end
      end

      def fatal?
        @fatal
      end

      def log_fatal_error
        logger.log("ESLint Error: #{message_text}")
        nil
      end
    end
  end
end
