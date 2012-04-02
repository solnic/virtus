require 'spec_helper'

describe Virtus::Attribute, '#default' do
  subject { object.default }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  context 'when the default is not specified' do
    it { should be_instance_of(Virtus::Attribute::DefaultValue) }

    its(:value) { should be_nil }
  end

  context 'when the default is specified' do
    let(:default) { stub('default') }

    before do
      options.update(:default => default)
    end

    it { should be_instance_of(Virtus::Attribute::DefaultValue::FromClonable) }

    its(:value) { should be(default) }
  end
end
