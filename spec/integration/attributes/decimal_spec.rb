require 'spec_helper'

describe Virtus::Attributes::Decimal do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :price }
    let(:attribute_value)       { BigDecimal("12.3456789") }
    let(:attribute_value_other) { "12.3456789" }
  end
end
