# frozen_string_literal: true

# Convenience functions:
def log(msg)
  log_info(msg)
end

def log_info(msg)
  APP_LOGGER.info msg
end

def log_error(msg)
  APP_LOGGER.error msg
end

def log_warn(msg)
  APP_LOGGER.warn msg
end

def log_debug(msg)
  APP_LOGGER.debug msg
end

# Example: log_secure! "Authorization Bearer token: #{Manager.first.api_key.auth_token}"
# $ grep-files-for 'Authorization Bearer token'
# ./log/development.log:123350:Authorization Bearer token: ********************
def log_secure(msg)
  if msg.include?(':')
    txt_ary = msg.split(':')
    plain_text = txt_ary[0]
    secure_text = '*' * txt_ary[1].strip.size
    msg = "#{plain_text}: #{secure_text}"
  else
    msg = '*' * msg.strip.size
  end
  Rails.logger.debug msg
end

# Send msg to Rails logger and console, used only by rake db:seed
def log!(msg)
  log_info(msg)
  puts(msg)
end

def log_err!(msg)
  log_error(msg)
  puts(msg)
end

def log_debug!(msg)
  log_secure(msg)
  puts(msg)
end

def log_secure!(msg)
  log_secure(msg)
  puts(msg)
end
