require 'spec_helper'

describe Virtus::Attribute::Collection, '#coerce_and_append_member' do
  subject { object.coerce_and_append_member(collection, entry) }

  let(:object)     { described_class.new('stuff') }
  let(:collection) { mock('collection')           }
  let(:entry)      { mock('entry')                }

  specify do
    expect { subject }.to raise_error(
      NotImplementedError,
      "Virtus::Attribute::Collection#coerce_and_append_member has not been implemented"
    )
  end
end
