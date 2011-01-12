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
  
  def from_file(name)
    root = self.respond_to?(:root) ? self.root : Rails.root
    file = root + 'config' + name
    
    settings = Choices.load_settings(file, Rails.respond_to?(:env) ? Rails.env : RAILS_ENV)
    @choices.update settings
    
    settings.each do |key, value|
      self.send("#{key}=", value)
    end
  end
end

if defined? Rails::Application::Configuration
  Rails::Application::Configuration.send(:include, Choices::Rails)
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
