require 'spec_helper'

describe Virtus::ValueObject, '.attribute' do
  subject { model.attributes[name] }

  let(:model) { Class.new { include Virtus::ValueObject } }
  let(:name)  { :lat  }
  let(:type)  { Float }

  before { model.attribute(name, type) }

  it { should be_instance_of(Virtus::Attribute::Float) }

  specify { subject.options[:writer].should be(:private) }
end
