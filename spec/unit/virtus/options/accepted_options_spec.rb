require 'spec_helper'

describe Virtus::Options, '#accepted_options' do
  subject { object.accepted_options }

  specify { object.should respond_to(:accepted_options) }

  let(:object) do
    Class.new do
      extend DescendantsTracker
      extend Virtus::Options
    end
  end

  let(:options) { [ :width, :height ] }

  before { object.accept_options(*options) }

  it { should be_instance_of(Array) }
  it { should include(*options)     }
end
