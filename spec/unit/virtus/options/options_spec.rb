require 'spec_helper'

describe Virtus::Options, '#options' do
  subject { object.options }

  specify { object.should respond_to(:options) }

  let(:object) { Class.new { extend Virtus::Options } }

  it { should be_instance_of(Hash) }
end
