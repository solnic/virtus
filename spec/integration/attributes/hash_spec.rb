require 'spec_helper'

describe Virtus::Attributes::Hash do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :settings }
    let(:attribute_value)       { Hash[:one => 1] }
    let(:attribute_value_other) { Hash[:two => 2] }
  end

  describe 'dirty tracking' do
    let(:model) do
      Class.new do
        include Virtus
        include Virtus::DirtyTracking

        attribute :settings, Hash
      end
    end

    let(:object) do
      model.new(:settings => {})
    end

    context "when value is set implicitly" do
      before do
        object.settings[:one] = '1'
      end

      it "marks the attribute as dirty" do
        object.attribute_dirty?(:settings).should be(true)
      end

      it "sets dirty attributes hash" do
        object.dirty_attributes.should == { :settings => { :one => '1' } }
      end
    end
  end
end
