require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromClonable, '.handle?' do
  subject { described_class.handle?(default) }

  let(:attribute) { mock('attribute') }

  context 'with a clonable' do
    let(:default) { 'clonable'  }

    it { should be(true)  }
  end

  context 'with a non-clonable' do
    let(:default) { 1 }

    it { should be(false)  }
  end
end
