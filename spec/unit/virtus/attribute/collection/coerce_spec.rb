require 'spec_helper'

describe Virtus::Attribute::Collection, '#coerce' do
  subject { attribute.coerce(value) }

  let(:attribute)   { Class.new(described_class).new(:things, :member_type => member_type) }
  let(:value)       { [ entry ] }
  let(:entry)       { mock('entry') }
  let(:member_type) { Virtus::Attribute::Object }

  before do
    value.should_receive(:respond_to?).with(:inject).and_return(respond_to_inject)
  end
  
  context 'when coerced value responds to #inject' do
    let(:respond_to_inject) { true }
  
    specify { expect { subject }.to raise_error(NotImplementedError) }
  end

  context 'when coerced value does not respond to #inject' do
    let(:respond_to_inject) { false }

    specify { should eql(value) }
  end
end