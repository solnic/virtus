require 'spec_helper'

describe Virtus::ValueObject, '.equalizer' do
  subject { described_class.equalizer }

  let(:described_class) do
    Class.new do
      include Virtus::ValueObject

      attribute :first_name, String
    end
  end

  specify { subject.should be_instance_of(Virtus::Equalizer) }
  specify { described_class.included_modules.should include(subject)      }

  context 'when equalizer is already initialized' do
    before { subject; described_class.equalizer }

    let(:equalizer) { subject }

    specify { subject.should be(equalizer) }
  end
end
