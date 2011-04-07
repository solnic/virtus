require 'spec_helper'

describe Character::Attributes::String do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :email }
    let(:attribute_value)       { 'red john' }
    let(:attribute_value_other) { :'red john' }
  end

  describe '#typecast' do
    let(:model)          { Class.new { include Character } }
    let(:attribute)      { model.attribute(:name, String) }
    let(:value)          { 1 }
    let(:typecast_value) { '1' }

    subject { attribute.typecast(value) }

    it { should == typecast_value }
  end
end
