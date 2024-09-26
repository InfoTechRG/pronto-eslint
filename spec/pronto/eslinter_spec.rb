# frozen_string_literal: true

require 'spec_helper'

module Pronto
  describe Eslinter do
    let(:eslint) { Eslinter.new(patches) }

    describe '#run' do
      subject(:run) { eslint.run }

      let(:eslint_doc_url) { 'https://eslint.org/docs/latest/rules/' }

      context 'when patches are nil' do
        let(:patches) { nil }

        it { should == [] }
      end

      context 'without patches' do
        let(:patches) { [] }

        it { should == [] }
      end

      context 'with an invalid eslint.config.js config' do
        include_context 'test repo'
        include_context 'eslint.config.js error'

        before do
          allow(eslint.logger).to receive(:log).and_call_original
        end

        let(:patches) { repo.diff('main') }

        its(:first) { is_expected.to be_nil }

        it 'logs a fatal error' do
          run
          expect(eslint.logger).to have_received(:log).with('ESLint Error: Parsing error: Invalid ecmaVersion.')
        end
      end

      context 'with patches including warnings' do
        include_context 'test repo'
        include_context 'eslint.config.js'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            'Opening curly brace does not appear on the same line as controlling statement. ' \
            "eslint([brace-style](#{eslint_doc_url}brace-style))",
            "Block must not be padded by blank lines. eslint([padded-blocks](#{eslint_doc_url}padded-blocks))",
            'More than 1 blank line not allowed. ' \
            "eslint([no-multiple-empty-lines](#{eslint_doc_url}no-multiple-empty-lines))",
            "Unnecessary return statement. eslint([no-useless-return](#{eslint_doc_url}no-useless-return))",
            "Missing semicolon. eslint([semi](#{eslint_doc_url}semi))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'with patches including suggestions' do
        include_context 'test repo'
        include_context 'eslint.config.js'
        include_context 'suggestions config'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))" \
            "\n\n```suggestion\nfunction Hello(name) {\n```",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            'Opening curly brace does not appear on the same line as controlling statement. ' \
            "eslint([brace-style](#{eslint_doc_url}brace-style))\n\n```suggestion\n\n```",
            "Block must not be padded by blank lines. eslint([padded-blocks](#{eslint_doc_url}padded-blocks))" \
            "\n\n```suggestion\n\n```",
            'More than 1 blank line not allowed. eslint([no-multiple-empty-lines]' \
            "(#{eslint_doc_url}no-multiple-empty-lines))\n\n```suggestion\n\n```",
            "Unnecessary return statement. eslint([no-useless-return](#{eslint_doc_url}no-useless-return))" \
            "\n\n```suggestion\n  \n}\nReallYBAdFunC()\n```",
            "Missing semicolon. eslint([semi](#{eslint_doc_url}semi))\n\n```suggestion\nReallYBAdFunC();\n```"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'when using a custom command' do
        include_context 'test repo'
        include_context 'eslint.config.js'
        include_context 'command config'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            'Opening curly brace does not appear on the same line as controlling statement. ' \
            "eslint([brace-style](#{eslint_doc_url}brace-style))",
            "Block must not be padded by blank lines. eslint([padded-blocks](#{eslint_doc_url}padded-blocks))",
            'More than 1 blank line not allowed. ' \
            "eslint([no-multiple-empty-lines](#{eslint_doc_url}no-multiple-empty-lines))",
            "Unnecessary return statement. eslint([no-useless-return](#{eslint_doc_url}no-useless-return))",
            "Missing semicolon. eslint([semi](#{eslint_doc_url}semi))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'when customizing the file filter' do
        include_context 'test repo'
        include_context 'eslint.config.js'
        include_context 'file filter config'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            'Opening curly brace does not appear on the same line as controlling statement. ' \
            "eslint([brace-style](#{eslint_doc_url}brace-style))",
            "Block must not be padded by blank lines. eslint([padded-blocks](#{eslint_doc_url}padded-blocks))",
            'More than 1 blank line not allowed. ' \
            "eslint([no-multiple-empty-lines](#{eslint_doc_url}no-multiple-empty-lines))",
            "Unnecessary return statement. eslint([no-useless-return](#{eslint_doc_url}no-useless-return))",
            "Missing semicolon. eslint([semi](#{eslint_doc_url}semi))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end
    end
  end
end
