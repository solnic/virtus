require 'spec_helper'

describe Virtus::ValueObject, '.attribute' do
  let(:object)    { Class.new { include Virtus::ValueObject } }
  let(:name)      { :location                                 }
  let(:type)      { Hash[Symbol => Float]                     }
  let(:attribute) { object.attribute_set[name]                }

  context 'without options' do
    subject { object.attribute(name, type) }

    it { should be(object) }

    it 'sets the writer to be private' do
      subject
      expect(attribute).to_not be_public_writer
    end
  end

  context 'with options' do
    subject { object.attribute(name, type, options) }

    let(:options) { { :default => default }  }
    let(:default) { { :lat => 1.0, :lng => 2.0 } }

    it { should be(object) }

    it 'sets the writer to be private' do
      subject
      expect(attribute).to_not be_public_writer
    end

    it 'sets the default' do
      subject
      attribute.writer.default_value.value.should eql(:lat => 1.0, :lng => 2.0)
    end
  end
end
