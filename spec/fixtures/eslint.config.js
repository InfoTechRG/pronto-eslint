import js from "@eslint/js";
import airbnbBaseBestPractices from "eslint-config-airbnb-base/rules/best-practices";
import airbnbBaseErrors from "eslint-config-airbnb-base/rules/errors";
import airbnbBaseStyle from "eslint-config-airbnb-base/rules/style";
import airbnbBaseVar from "eslint-config-airbnb-base/rules/variables";
import airbnbBaseStrict from "eslint-config-airbnb-base/rules/strict";

export default [
  js.configs.recommended,
  airbnbBaseBestPractices,
  airbnbBaseErrors,
  airbnbBaseStyle,
  airbnbBaseVar,
  airbnbBaseStrict,
  {
    "languageOptions": {
      "parserOptions": {
        "ecmaVersion": 6,
        "sourceType": "module"
      }
    }
  }
];
