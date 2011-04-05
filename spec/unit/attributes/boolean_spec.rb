require 'spec_helper'

describe Character::Attributes::Boolean do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :is_admin }
  end
end
