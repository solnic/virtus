require 'spec_helper'

describe Virtus::ClassMethods, '.attributes' do
  subject { described_class.attributes }

  let(:described_class) do
    Class.new { extend Virtus::ClassMethods }
  end

  it { should be_instance_of(Virtus::AttributeSet) }
end
