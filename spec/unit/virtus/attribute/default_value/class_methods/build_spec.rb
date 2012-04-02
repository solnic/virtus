require 'spec_helper'

describe Virtus::Attribute::DefaultValue, '.build' do
  subject { described_class.build(default) }

  context 'when default is a symbol' do
    let(:default) { :symbol }

    it { should be_instance_of(Virtus::Attribute::DefaultValue::FromSymbol)  }
  end

  context 'when default is a callable' do
    let(:default) { Proc.new {} }

    it { should be_instance_of(Virtus::Attribute::DefaultValue::FromCallable)  }
  end

  context 'when default is a clonable' do
    let(:default) { "I can be cloned" }

    it { should be_instance_of(Virtus::Attribute::DefaultValue::FromClonable)  }
  end
end
