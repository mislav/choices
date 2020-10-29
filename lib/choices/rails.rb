require 'hashie/mash'
require 'choices'

module Choices::Rails
  def self.included(base)
    base.class_eval do
      def initialize_with_choices(*args, &block)
        initialize_without_choices(*args, &block)
        @choices = Hashie::Mash.new
      end

      alias :initialize_without_choices :initialize
      alias :initialize :initialize_with_choices
    end
  end

  def from_hash(hash)
    raise "Expecting hash received #{hash.class}" unless hash.is_a?(Hash)

    settings = Hashie::Mash.new(hash)
    dynamically_load_settings(settings)
  end

  def from_file(name, env=nil)
    if name.relative?
      root = self.respond_to?(:root) ? self.root : Rails.root
      file = root + 'config' + name
    else
      file = name
    end

    env = Rails.respond_to?(:env) ? Rails.env : RAILS_ENV if env.nil?

    settings = Choices.load_settings(file, env)
    dynamically_load_settings(settings)
  end

  def from_files(names, env=nil)
    files = []
    names.each do |name|
      if name.relative?
        root = self.respond_to?(:root) ? self.root : Rails.root
        files << root + 'config' + name
      else
        files << name
      end
    end

    env = Rails.respond_to?(:env) ? Rails.env : RAILS_ENV if env.nil?

    settings = Choices.load_settings_from_files(files, env)
    dynamically_load_settings(settings)
  end

  def dynamically_load_settings(settings)
    @choices.update settings

    settings.each do |key, value|
      old_value = self.respond_to?(key) ? self.send(key) : nil

      if "Rails::OrderedOptions" == old_value.class.name
        # convert from Array to a real Hash
        old_value = old_value.inject({}) {|h,(k,v)| h[k]=v; h }
      end

      if Hash === value and Hash === old_value
        # don't overwrite existing Hash values; deep update them
        value = Hashie::Mash.new(old_value).update value
      end

      self.send("#{key}=", value)
    end
  end
end

if defined? Rails::Engine::Configuration
  Rails::Engine::Configuration.send(:include, Choices::Rails)
elsif defined? Rails::Configuration
  Rails::Configuration.class_eval do
    include Choices::Rails
    include Module.new {
      def respond_to?(method)
        super or method.to_s =~ /=$/ or (method.to_s =~ /\?$/ and @choices.key?($`))
      end

      private

      def method_missing(method, *args, &block)
        if method.to_s =~ /=$/ or (method.to_s =~ /\?$/ and @choices.key?($`))
          @choices.send(method, *args)
        elsif @choices.key?(method)
          @choices[method]
        else
          super
        end
      end
    }
  end
end
