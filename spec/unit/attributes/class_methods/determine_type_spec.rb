require 'spec_helper'

describe Character::Attributes, '.determine_type' do

  (Character::Attributes::Object.descendants - [
   Character::Attributes::Boolean,
   Character::Attributes::Object,
   Character::Attributes::Numeric ]).each do |attribute_class|

    context "with #{attribute_primitive = attribute_class.primitive}" do
      subject { described_class.determine_type(attribute_primitive) }

      it "returns the corresponding attribute class" do
        subject.should be(attribute_class)
      end
    end

  end

end
