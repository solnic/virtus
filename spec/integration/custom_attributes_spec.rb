require 'spec_helper'

describe 'custom attributes' do

  before do
    module Examples
      class NoisyString < Virtus::Attribute
        lazy true

        def coerce(input)
          input.to_s.upcase
        end
      end

      class RegularExpression < Virtus::Attribute
        primitive Regexp
      end

      class User
        include Virtus

        attribute :name, String
        attribute :scream, NoisyString
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
