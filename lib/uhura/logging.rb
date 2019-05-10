def log(msg, event_type_id = AppCfg['LOG_INFO_ID'], source_id = AppCfg['SOURCE_SERVER_ID'])
  Ulog.create!(source_id: source_id, event_type_id: event_type_id, details: msg)
end
# log_info(...) is same as calling log(msg) without source_id or event_type_id params
def log_info(msg)
  log(msg, AppCfg['LOG_INFO_ID'])
end

def log_error(msg)
  log(msg, AppCfg['LOG_ERROR_ID'])
end

def log_warning(msg)
  log(msg, AppCfg['LOG_WARNING_ID'])
end


def log_puts(msg)
  log(msg)
  puts(msg)
end

def log_err_puts(msg)
  log_error(msg)
  puts(msg)
end
