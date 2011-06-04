require 'spec_helper'

describe Virtus::Attributes::Array do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :colors }
    let(:attribute_value)       { [ 'red', 'green', 'blue' ] }
    let(:attribute_value_other) { [ 'orange', 'yellow', 'gray' ] }
  end
end
