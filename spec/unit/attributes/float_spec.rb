require 'spec_helper'

describe Character::Attributes::Float do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :unit }
  end
end
