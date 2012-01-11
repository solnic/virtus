require 'digest'
require './spec/spec_helper'

class Md5 < Virtus::Attribute::Object
  primitive       String
  coercion_method :to_md5
end

module Virtus
  class Coercion
    class String < Virtus::Coercion::Object
      def self.to_md5(value)
        Digest::MD5.hexdigest(value)
      end
    end
  end
end

class User
  include Virtus

  attribute :name,     String
  attribute :password, Md5
end

describe User do
  it { should respond_to(:name)      }
  it { should respond_to(:name=)     }
  it { should respond_to(:password)  }
  it { should respond_to(:password=) }

  describe '#name=' do
    let(:value) { 'Piotr' }

    before do
      subject.name = value
    end

    its(:name) { should == value }
  end

  describe '#password=' do
    let(:value) { 'foobar' }

    before do
      subject.password = value
    end

    its(:password) { should == Virtus::Coercion::String.to_md5(value) }
  end
end
