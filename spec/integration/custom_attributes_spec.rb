require 'spec_helper'

describe 'custom attributes' do

  module Virtus
    class Coercion
      class String < Virtus::Coercion::Object
        def self.to_upcase(value)
          value.upcase
        end
      end
    end
  end

  before do
    module Examples
      class UpperCase < Virtus::Attribute::Object
        primitive String
        coercion_method :to_upcase
      end

      class RegularExpression < Virtus::Attribute::Object
        primitive Regexp
      end

      class User
        include Virtus

        attribute :name, String
        attribute :scream, UpperCase
        attribute :expression, RegularExpression
      end
    end
  end

  subject { Examples::User.new }

  specify 'allows you to define custom attributes' do
    regexp = /awesome/
    subject.expression = regexp
    subject.expression.should == regexp
  end

  specify 'allows you to define coercion methods' do
    subject.scream = 'welcome'
    subject.scream.should == 'WELCOME'
  end

end
