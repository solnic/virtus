require 'spec_helper'

describe Character::Attributes::Decimal do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :price }
  end
end
