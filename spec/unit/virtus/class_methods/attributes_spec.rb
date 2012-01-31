require 'spec_helper'

describe Virtus::ClassMethods, '#attributes' do
  subject { object.attributes }

  let(:object) { Class.new { extend Virtus::ClassMethods } }

  it { should be_instance_of(Virtus::AttributeSet) }
end
