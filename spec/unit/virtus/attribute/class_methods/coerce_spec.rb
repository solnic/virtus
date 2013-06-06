require 'spec_helper'

describe Virtus::Attribute, '.coerce' do
  subject { described_class.coerce }

  before do
    @original_stderr, $stderr = $stderr, StringIO.new
  end

  after do
    $stderr = @original_stderr
  end

  # it { expect(subject).to be_kind_of(Virtus::Attribute) }

  it 'returns a deprecation warning' do
    subject
    $stderr.string.should =~ /\AVirtus::Attribute.coerce is deprecated and will be removed in a future version. Use Virtus.coerce instead: ##{__FILE__}:4\b/
  end

  context 'when value is Undefined' do
    subject { described_class.coerce }

    it 'returns Virtus.coerce' do
      expect(subject).to be(Virtus.coerce)
    end
  end

  context 'when value is supplied' do
    subject { described_class.coerce(false) }

    after do
      Virtus.coerce = true
    end

    it { expect(subject).to be(Virtus::Attribute) }

    it 'modifies Virtus.coerce' do
      subject
      expect(Virtus.coerce).to be(false)
    end
  end
end
