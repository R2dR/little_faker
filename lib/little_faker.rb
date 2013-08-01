require 'faker'
#Exposes all Faker methods under to Fake class
# ie.
module Faker
  module FakerMethodsDelegator
  
    class << self
      def faker_method_modules
        Faker.constants
          .map{|c| Faker.const_get(c)}
          .select{|const| const.is_a?(Class) && const.superclass == Faker::Base}
      end
      
      def faker_methods_hash
        Hash[
          *faker_method_modules.map do |faker_mod|
            (faker_mod.methods - Faker::Base.methods).map do |method_name|
              [method_name, faker_mod.method(method_name)]
            end
          end.flatten
        ]
      end
    end    
  
    def self.included(base)
      base.class_eval do
        @faker_methods_hash = FakerMethodsDelegator.faker_methods_hash
        class << self
          include ClassDelegationMethods
          alias_method :respond_to_without_faker_methods?, :respond_to?
          alias_method :respond_to?, :respond_to_with_faker_methods?
        end
      end
    end
  
    module ClassDelegationMethods
      def respond_to_with_faker_methods?(method_name, include_all=false)
        if @faker_methods_hash[method_name]
          true
        else
          respond_to_without_faker_methods?(method_name, include_all)
        end
      end
  
      def method_missing(method_name, *args, &block)
        if (method = @faker_methods_hash[method_name])
          method.call(*args, &block)
        else
          super
        end
      end
  
      def faker_methods
        @faker_methods_hash.keys
      end
    end
  end
end
  
class Fake < Faker::Base
  include Faker::FakerMethodsDelegator

  class << Fake
    #def password(size=12)
    #  words(3).join[0,size]
    #end
  end
end

