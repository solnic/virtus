require 'spec_helper'

describe Character::Attributes::String do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :email }
  end
end
