require 'spec_helper'

describe Virtus::Attribute::DefaultValue::FromCallable, '.handle?' do
  subject { described_class.handle?(default) }

  context 'with a callable' do
    let(:default) { Proc.new {}  }

    it { should be(true)  }
  end

  context 'with a non-callable' do
    let(:default) { '' }

    it { should be(false)  }
  end
end
