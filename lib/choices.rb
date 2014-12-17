require 'hashie/mash'
require 'erb'
require 'yaml'

module Choices
  extend self
  
  def load_settings(filename, env)
    mash = Hashie::Mash.new(load_settings_hash(filename))
    
    with_local_settings(filename, '.local') do |local|
      mash.update local
    end

    env_mash = mash.fetch(env) do
      raise IndexError, %{Missing key for "#{env}" in `#{filename}'}
    end

    substitute_variables(env_mash, filename)
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

  def substitute_variables(mash, filename)
    mash.deep_update(mash) do |_, value|
      if value.respond_to?(:gsub!)
        value.gsub!(/%\{(.+?)\}/) do |parameter|
          $1.split('.').inject(mash) do |result, key|
            raise IndexError, %{Missing key for "#{parameter}" in `#{filename}'} unless result.respond_to? :[]
            result[key]
          end
        end
      end

      value
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
end

if defined? Rails
  require 'choices/rails'
end
