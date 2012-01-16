require 'spec_helper'

describe Virtus::Attribute::Numeric, '.min' do
  subject { object.min(value) }

  let(:object) { described_class }
  let(:value)  { stub('value')   }

  it { should equal(object) }

  it 'sets the min default for the class' do
    expect { subject }.to change { object.min }.from(nil).to(value)
  end
end
