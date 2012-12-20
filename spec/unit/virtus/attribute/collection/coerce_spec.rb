require 'spec_helper'

describe Virtus::Attribute::Collection, '#coerce' do
  subject { object.coerce(value) }

  let(:described_class) { Class.new(Virtus::Attribute::Collection) }
  let(:object)          { described_class.new(:things)             }
  let(:primitive)       { ::Array                                  }
  let(:entry)           { mock('entry')                            }

  before do
    described_class.primitive primitive
  end

  context 'when coerced value responds to #each_with_object' do
    let(:value) { [ entry ] }

    context 'when the object has not implemented #coerce_and_append_member' do
      specify { expect { subject }.to raise_error(NotImplementedError, "#{object.class}#coerce_and_append_member has not been implemented") }
    end

    context 'when the object has implemented #coerce_and_append_member' do
      before do
        def object.coerce_and_append_member(collection, entry)
          collection << entry
        end
      end

      it { should be_instance_of(primitive) }

      it { should == value }

      it { should_not equal(value) }
    end
  end

  context 'when coerced value does not respond to #each_with_object' do
    let(:value) { stub }

    it { should equal(value) }
  end
end
