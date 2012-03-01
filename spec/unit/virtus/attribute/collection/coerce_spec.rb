require 'spec_helper'

describe Virtus::Attribute::Collection, '#coerce' do
  subject { object.coerce(value) }

  let(:described_class) { Class.new(Virtus::Attribute::Collection) }
  let(:object)          { described_class.new(:things) }
  let(:value)           { [ entry ] }
  let(:entry)           { mock('entry') }

  before do
    described_class.primitive ::Array
    value.should_receive(:respond_to?).with(:inject).and_return(respond_to_inject)
  end

  context 'when coerced value responds to #inject' do
    let(:respond_to_inject) { true }

    context 'when the object has not implemented #coerce_and_append_member' do
      specify { expect { subject }.to raise_error(NotImplementedError, "#{object.class}#coerce_and_append_member has not been implemented") }
    end

    context 'when the object has implemented #coerce_and_append_member' do
      before do
        def object.coerce_and_append_member(collection, entry)
          collection << entry
        end
      end

      it { should eql(value) }
    end
  end

  context 'when coerced value does not respond to #inject' do
    let(:respond_to_inject) { false }

    it { should eql(value) }
  end
end
