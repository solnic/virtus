require 'spec_helper'

describe Virtus::Attribute::Collection::MemberCoercion, '#coerce_and_append_member' do
  subject { object.coerce_and_append_member(collection, entry) }

  let(:attribute_class) do
    Class.new(Virtus::Attribute::Collection) do
      include Virtus::Attribute::Collection::MemberCoercion
      self
    end
  end

  let(:object)     { attribute_class.new('stuff', :member_type => Integer) }
  let(:collection) { []  }
  let(:entry)      { '1' }

  it { should eql([ 1 ]) }
end
