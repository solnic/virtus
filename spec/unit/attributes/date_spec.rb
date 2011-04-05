require 'spec_helper'

describe Character::Attributes::Date do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :created_on }
  end
end
