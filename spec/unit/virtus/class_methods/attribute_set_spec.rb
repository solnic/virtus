require 'spec_helper'

describe Virtus::ClassMethods, '#attribute_set' do
  subject { object.attribute_set }

  let(:object) { Class.new { extend Virtus::ClassMethods } }

  it { should be_instance_of(Virtus::AttributeSet) }
end
