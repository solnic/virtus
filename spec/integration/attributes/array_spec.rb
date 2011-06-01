require 'spec_helper'

describe Virtus::Attributes::Array do
  it_should_behave_like 'Dirty Trackable Attribute' do
    let(:attribute_name)        { :colors }
    let(:attribute_value)       { [ 'red', 'green', 'blue' ] }
    let(:attribute_value_other) { [ 'orange', 'yellow', 'gray' ] }
  end

  describe 'dirty tracking' do
    let(:model) do
      Class.new do
        include Virtus
        include Virtus::DirtyTracking

        attribute :colors, Array
      end
    end

    let(:object) do
      model.new(:colors => [])
    end

    context "when value is set implicitly" do
      before do
        object.colors << 'gray'
      end

      it "marks the attribute as dirty" do
        object.attribute_dirty?(:colors).should be(true)
      end

      it "sets dirty attributes hash" do
        object.dirty_attributes.should == { :colors => ['gray'] }
      end
    end
  end
end
