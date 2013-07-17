require 'hashie/mash'
require 'erb'

module Choices
  extend self
  
  def load_settings(filename, env)
    mash = Hashie::Mash.new(load_settings_hash(filename))
    
    with_local_settings(filename, '.local') do |local|
      mash.update local
    end
    
    unless mash.has_key? env
      raise EnvironmentMissingError, "You are missing environment (#{env}) in #{filename}."
    end
    return mash[env]
  end

  def load_settings_hash(filename)
    yaml_content = ERB.new(IO.read(filename)).result
    yaml_load(yaml_content)
  end
  
  def with_local_settings(filename, suffix)
    local_filename = filename.sub(/(\.\w+)?$/, "#{suffix}\\1")
    if File.exists? local_filename
      hash = load_settings_hash(local_filename)
      yield hash if hash
    end
  end
  
  def yaml_load(content)
    if defined?(YAML::ENGINE) && defined?(Syck)
      # avoid using broken Psych in 1.9.2
      old_yamler = YAML::ENGINE.yamler
      YAML::ENGINE.yamler = 'syck'
    end
    begin
      YAML::load(content)
    ensure
      YAML::ENGINE.yamler = old_yamler if defined?(YAML::ENGINE) && defined?(Syck)
    end
  end

  class EnvironmentMissingError < StandardError; end;
end

if defined? Rails
  require 'choices/rails'
end
