# frozen_string_literal: true

RSpec.shared_context 'eslint pre config deprecation' do
  before(:all) do
    FileUtils.mv('spec/fixtures/.eslintrc.yml', '.eslintrc.yml')
    `yarn remove eslint 2>&1 > /dev/null`
    `yarn add eslint@8.57.0 eslint-config-airbnb-base eslint-plugin-import 2>&1 > /dev/null`
  end
  after(:all) do
    FileUtils.mv('.eslintrc.yml', 'spec/fixtures/.eslintrc.yml')
    `yarn remove eslint 2>&1 > /dev/null`
    `yarn remove eslint-config-airbnb-base 2>&1 > /dev/null`
    `yarn remove eslint-plugin-import 2>&1 > /dev/null`
    `yarn add eslint@latest eslint-config-airbnb-base eslint-plugin-import 2>&1 > /dev/null`
  end
end
