require 'spec_helper'

describe Virtus::ValueObject::ClassMethods, '#allowed_writer_methods' do
  subject { object.allowed_writer_methods }

  let(:object) do
    Class.new do
      include Virtus::ValueObject
      attribute :virtus_attribute, String
    end
  end

  it { should include('virtus_attribute=') }
  it { should be_frozen }
end
