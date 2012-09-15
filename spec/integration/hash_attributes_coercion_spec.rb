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

    it { should have(3).keys }
    it { should have_key :width  }
    it { should have_key :height }
    it { should have_key :length }

    it 'should be coerced to [Symbol => Float] format' do
      dimensions[:width].should  be_eql(2.2)
      dimensions[:height].should be_eql(2.0)
      dimensions[:length].should be_eql(4.5)
    end
  end

  describe '#meta_info' do
    subject { meta_info }

    it { should have(2).keys }
    it { should have_key 'from' }
    it { should have_key 'to'   }

    it 'should be coerced to [String => String] format' do
      meta_info['from'].should == 'Me'
      meta_info['to'].should == 'You'
    end
  end
end
