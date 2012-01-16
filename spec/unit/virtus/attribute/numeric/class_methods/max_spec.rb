require 'spec_helper'

describe Virtus::Attribute::Numeric, '.max' do
  subject { object.max(value) }

  let(:object) { described_class }
  let(:value)  { stub('value')   }

  it { should equal(object) }

  it 'sets the max default for the class' do
    expect { subject }.to change { object.max }.from(nil).to(value)
  end
end
