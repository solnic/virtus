require 'spec_helper'


class Package
  include Virtus

  attribute :dimensions, Hash[Symbol => Float]
  attribute :meta_info , Hash[String => String]
end


describe Package do
  let(:instance) do
    described_class.new(
      :dimensions => { 'width' => "2.2", :height => 2, "length" => 4.5 },
      :meta_info  => { 'from'  => :Me  , :to => 'You' }
    )
  end

  let(:dimensions) { instance.dimensions }
  let(:meta_info)  { instance.meta_info  }

  describe '#dimensions' do
    subject { dimensions }

    it 'has 3 keys' do
      expect(subject.keys.size).to eq(3)
    end
    it { is_expected.to have_key :width  }
    it { is_expected.to have_key :height }
    it { is_expected.to have_key :length }

    it 'should be coerced to [Symbol => Float] format' do
      expect(dimensions[:width]).to  be_eql(2.2)
      expect(dimensions[:height]).to be_eql(2.0)
      expect(dimensions[:length]).to be_eql(4.5)
    end
  end

  describe '#meta_info' do
    subject { meta_info }

    it 'has 2 keys' do
      expect(subject.keys.size).to eq(2)
    end
    it { is_expected.to have_key 'from' }
    it { is_expected.to have_key 'to'   }

    it 'should be coerced to [String => String] format' do
      expect(meta_info['from']).to eq('Me')
      expect(meta_info['to']).to eq('You')
    end
  end
end
