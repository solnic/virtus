require 'spec_helper'

describe Virtus::Options, '#accept_options' do
  let(:object) do
    Class.new do
      extend Virtus::DescendantsTracker
      extend Virtus::Options
    end
  end

  let(:descendant) { Class.new(object) }
  let(:new_option) { :width }

  specify { object.should     respond_to(:accept_options) }
  specify { descendant.should respond_to(:accept_options) }

  before :all do
    object.accepted_options.should_not include(new_option)
    descendant.accepted_options.should_not include(new_option)
    object.accept_options(new_option)
  end

  it "sets new accepted options on itself" do
    object.accepted_options.should include(new_option)
  end

  it "sets new accepted option on its descendants" do
    descendant.accepted_options.should include(new_option)
  end

  it "creates option accessors" do
    object.should respond_to(new_option)
  end

  it "creates option accessors on descendant" do
    descendant.should respond_to(new_option)
  end
end
