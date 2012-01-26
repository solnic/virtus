require 'spec_helper'

describe Virtus::Attribute, '#get!' do
  subject { object.get!(instance) }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }
  let(:instance)        { Object.new                                                       }

  context 'when the instance variable is set' do
    let(:value) { stub('value') }

    before do
      instance.instance_variable_set(:@name, value)
    end

    it 'gets the instance variable value' do
      should be(value)
    end
  end

  context 'when the instance variable is not set' do
    it 'returns nil' do
      should be_nil
    end
  end
end
