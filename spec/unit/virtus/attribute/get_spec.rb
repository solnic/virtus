require 'spec_helper'

describe Virtus::Attribute, '#get' do
  subject { object.get(instance) }

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

    it 'gets the value from the instance variable' do
      should be(value)
    end
  end

  context 'when the instance variable is not set' do
    context 'when there is no default' do
      it 'returns nil' do
        should be_nil
      end

      it 'sets the ivar' do
        expect { subject }.to change { instance.instance_variable_defined?(:@name) }.from(false).to(true)
      end
    end

    context 'when there is a default' do
      let(:default) { stub('default') }

      before do
        default.stub(:clone).and_return(default)
        options.update(:default => default)
      end

      it 'gets the default from the instance variable' do
        should be(default)
      end
    end
  end
end

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

    it 'gets the value from the instance variable' do
      should be(value)
    end
  end

  context 'when the instance variable is not set' do
    it 'returns nil' do
      should be_nil
    end

    it 'does not set the ivar' do
      expect { subject }.to_not change { instance.instance_variable_defined?(:@name) }
    end
  end
end
