require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromSymbol, '.handle?' do
  subject { described_class.handle?(default) }

  context 'with a symbol' do
    let(:default) { :method_name  }

    it { should be(true)  }
  end

  context 'with a non-symbol' do
    let(:default) { 'method_name' }

    it { should be(false)  }
  end
end
