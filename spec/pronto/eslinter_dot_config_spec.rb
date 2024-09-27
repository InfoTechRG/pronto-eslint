# frozen_string_literal: true

require 'spec_helper'

module Pronto
  describe Eslinter do
    let(:eslint) { Eslinter.new(patches) }

    describe '#run' do
      subject(:run) { eslint.run }

      let(:eslint_doc_url) { 'https://eslint.org/docs/latest/rules/' }

      include_context 'eslint pre config deprecation'

      context 'when using dot config on a pre-deprecation release of eslint' do
        include_context 'test repo'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            'Opening curly brace does not appear on the same line as controlling statement. ' \
            "eslint([brace-style](#{eslint_doc_url}brace-style))",
            "Block must not be padded by blank lines. eslint([padded-blocks](#{eslint_doc_url}padded-blocks))",
            'More than 1 blank line not allowed. eslint([no-multiple-empty-lines]' \
            "(#{eslint_doc_url}no-multiple-empty-lines))",
            "Unnecessary return statement. eslint([no-useless-return](#{eslint_doc_url}no-useless-return))",
            "Missing semicolon. eslint([semi](#{eslint_doc_url}semi))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'when using dot config on a pre-deprecation release of eslint with suggestions' do
        include_context 'test repo'
        include_context 'suggestions config'

        let(:patches) { repo.diff('main') }
        let(:eslint_doc_url) { 'https://eslint.org/docs/latest/rules/' }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            'Opening curly brace does not appear on the same line as controlling statement. ' \
            "eslint([brace-style](#{eslint_doc_url}brace-style))\n\n```suggestion\nfunction ReallYBAdFunC() {\n```",
            "Block must not be padded by blank lines. eslint([padded-blocks](#{eslint_doc_url}padded-blocks))",
            'More than 1 blank line not allowed. eslint([no-multiple-empty-lines]' \
            "(#{eslint_doc_url}no-multiple-empty-lines))",
            "Unnecessary return statement. eslint([no-useless-return](#{eslint_doc_url}no-useless-return))" \
            "\n\n```suggestion\n  \n}\nReallYBAdFunC()\n```",
            "Missing semicolon. eslint([semi](#{eslint_doc_url}semi))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end
    end
  end
end
