require 'spec_helper'

describe Character::Attributes::Time do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :birthday }
  end
end
