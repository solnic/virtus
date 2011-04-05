require 'spec_helper'

describe Character::Attributes::Integer do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :age }
  end
end
