require 'spec_helper'

describe Character::Attributes::DateTime do
  it_should_behave_like 'Attribute' do
    let(:attribute_name) { :created_at }
  end
end
