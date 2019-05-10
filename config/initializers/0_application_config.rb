ENVied.require(*ENV["ENVIED_GROUPS"] || Rails.groups)

# Load ENV vars into AppCfg.  Example usage: AppCfg['ENV_VAR_NAME']
class AppCfg
  def self.[](key)
    ENVied.send(key)
  end
end
