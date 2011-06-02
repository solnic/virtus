require 'spec_helper'

describe Virtus::Attributes::Boolean do
  it_should_behave_like 'Attribute' do
    let(:attribute_name)        { :is_admin }
    let(:attribute_value)       { true }
    let(:attribute_value_other) { '1' }
  end

  describe "accessor names" do
    let(:model) do
      Class.new do
        include Virtus
        
        attribute :is_admin, Virtus::Attributes::Boolean
      end
    end
    
    let(:object) { model.new(:is_admin => true) }
    
    it "uses standard boolean reader naming conventions" do
      object.is_admin?.should be_true
    end
  end

  describe '#typecast' do
    let(:model)     { Class.new { include Virtus } }
    let(:attribute) { model.attribute(:is_admin, Virtus::Attributes::Boolean) }

    subject { attribute.typecast(value) }

    context "with 1" do
      let(:value) { 1 }
      it { should be(true) }
    end

    context "with '1'" do
      let(:value) { '1' }
      it { should be(true) }
    end

    context "with 'true'" do
      let(:value) { 'true' }
      it { should be(true) }
    end

    context "with 'TRUE'" do
      let(:value) { 'TRUE' }
      it { should be(true) }
    end

    context "with 't'" do
      let(:value) { 't' }
      it { should be(true) }
    end

    context "with 'T'" do
      let(:value) { 'T' }
      it { should be(true) }
    end

    context "with 0" do
      let(:value) { 0 }
      it { should be(false) }
    end

    context "with '0'" do
      let(:value) { '0' }
      it { should be(false) }
    end

    context "with 'false'" do
      let(:value) { 'false' }
      it { should be(false) }
    end

    context "with 'FALSE'" do
      let(:value) { 'FALSE' }
      it { should be(false) }
    end

    context "with 'f'" do
      let(:value) { 'f' }
      it { should be(false) }
    end

    context "with 'F'" do
      let(:value) { 'F' }
      it { should be(false) }
    end

    context "with 'Foo'" do
      let(:value) { 'Foo' }
      it { should == value }
    end
  end
end
