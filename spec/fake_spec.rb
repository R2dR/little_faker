require 'spec_helper'
require_relative '../lib/little_faker'

shared_examples_for :responder_of do |mod|
  context "module #{mod.to_s}" do
    (mod.methods - Faker::Base.methods).each do |method_name|
      it "recognizes '#{method_name}' method" do
        Fake.respond_to?(method_name).should be_true
      end
    end
  end
end
shared_examples_for :faker_for do |mod|
  context "module #{mod.to_s}" do
    (mod.methods - Faker::Base.methods).each do |method_name|
      it "method '#{method_name}' returns something" do
        expect{ Fake.send method_name }.to_not be_nil
      end
    end
  end
end

FAKER_MODULES = [
  Faker::Company, Faker::Name, Faker::PhoneNumber,
  Faker::Address, Faker::Lorem, Faker::Business,
  Faker::Code, Faker::Number, Faker::Commerce
]

describe Fake do

  describe ".respond_to?" do    
    FAKER_MODULES.each do |mod|
      it_behaves_like :responder_of, mod
    end
    context "Faker::Base inherited methods" do
      (Faker::Base.methods - Object.methods).each do |method_name|
        it "recognizes '#{method_name}' method" do
          Fake.respond_to?(method_name).should be_true
        end
      end
    end
  end  
  
  
  describe ".faker_methods" do
    it "exists" do
      Fake.method(:faker_methods).should_not be_nil
    end
    it "is recognized" do
      Fake.respond_to?(:faker_methods).should be_true
    end
    it "returns array" do
      Fake.faker_methods.should be_kind_of(Array)
    end
    it "is not empty" do
      Fake.faker_methods.should_not be_empty
    end
    it "returns symbol in elements" do
      Fake.faker_methods.first.should be_kind_of(Symbol)
    end
  end
  
  describe "delegation" do
    FAKER_MODULES.each do |mod|
      it_behaves_like :faker_for, mod
    end
  end
  
  describe "specific faker methods" do
    it ".email returns email" do
      Fake.email.should =~ /[\w.-_]+@[\w.-_]+/
    end
  end
  
  context "custom methods" do
    describe ".password_of_length" do
      it "defaults to length 12" do
        Fake.password_of_length.length.should == 12
      end
      it "returns password of large length" do
        Fake.password_of_length(100).length.should == 100
      end
    end
  end
end

