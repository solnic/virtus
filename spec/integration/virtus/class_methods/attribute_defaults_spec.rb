require 'spec_helper'

describe Virtus::ClassMethods, '.attribute' do
  context 'overriding default values in descentant' do
    let(:described_class) do 
      Class.new do 
        def self.name; 'Base'; end
        include Virtus
      end
    end

    let(:descendant) do 
      Class.new(described_class) do
        def self.name; 'Descendant'; end
      end
    end

    before do
      described_class.attribute :name, String, :default => 'Base Default'
      descendant.attribute      :name, String, :default => 'Descendant Default'
    end

   #it 'updates the default value of descendant' do
   #  descendant.new.name.should == 'Descendant Default'
   #end

    it 'retains the default value of base class' do
      described_class.new.name.should == 'Base Default'
    end
  end
end
