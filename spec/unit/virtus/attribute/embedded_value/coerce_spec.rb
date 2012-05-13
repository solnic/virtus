require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '#coerce' do
  subject { object.coerce(value) }

  let(:object)   { described_class.new(:name, :primitive => primitive) }
  let(:instance) { Object.new                                          }
  let(:value)    { primitive.new                                       }

  context 'when the value is a virtus object' do
    let(:primitive) { Class.new { include Virtus } }

    it { should be(value) }
  end

  context 'when the value is a virtus value object' do
    let(:primitive) { Class.new { include Virtus::ValueObject } }

    it { should be(value) }
  end
end
