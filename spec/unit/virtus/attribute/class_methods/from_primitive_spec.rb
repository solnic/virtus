require 'spec_helper'

describe Virtus::Attribute, '.from_primitive' do
  subject { object.from_primitive(primitive) }

  let(:object) { described_class }

  context 'when the primitive maps to an Attribute' do
    let(:primitive) { String }

    it { should equal(Virtus::Attribute::String) }
  end

  context 'when the primitive defaults to Object' do
    let(:primitive) { Class.new }

    it { should equal(Virtus::Attribute::Object) }
  end
end
