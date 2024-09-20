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
            "Expected a function expression. eslint([func-style](#{eslint_doc_url}func-style))",
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Expected { after 'if' condition. eslint([curly](#{eslint_doc_url}curly))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))"
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
            "Expected a function expression. eslint([func-style](#{eslint_doc_url}func-style))",
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Expected { after 'if' condition. eslint([curly](#{eslint_doc_url}curly))" \
            "\n\n```suggestion\n  if (foo) {foo++;}\n```",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))"
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
            "Expected a function expression. eslint([func-style](#{eslint_doc_url}func-style))",
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Expected { after 'if' condition. eslint([curly](#{eslint_doc_url}curly))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))"
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
            "Expected a function expression. eslint([func-style](#{eslint_doc_url}func-style))",
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Expected { after 'if' condition. eslint([curly](#{eslint_doc_url}curly))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))",
            "'alert' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end
    end
  end
end
