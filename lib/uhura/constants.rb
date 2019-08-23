# frozen_string_literal: true

# Matches:  "bob@example.com" as well as "Bob Brown <bob@example.com>"
# rubocop:disable Style/MutableConstant, Style/RegexpLiteral, Metrics/LineLength
RFC5233_EMAIL_REGEXP = /\A#{URI::MailTo::EMAIL_REGEXP}|.+\<[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\>\z/
# rubocop:enable Style/MutableConstant, Style/RegexpLiteral, Metrics/LineLength
