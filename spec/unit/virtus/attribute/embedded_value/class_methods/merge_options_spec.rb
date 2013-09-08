require 'spec_helper'

describe Virtus::Attribute::EmbeddedValue, '.merge_options' do
  subject { object.merge_options(type, options) }

  let(:object)  { described_class }
  let(:type)    { OpenStruct      }
  let(:options) { {}.freeze       }

  it { should be_instance_of(Hash) }

  it { should_not equal(options) }

  it 'merges the type in as the model' do
    should include(:primitive => type)
  end
end
