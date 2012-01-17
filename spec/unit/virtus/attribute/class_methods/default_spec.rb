require 'spec_helper'

describe Virtus::Attribute, '.default' do
  let(:object)  { Class.new(described_class) }
  let(:method)  { :default                   }
  let(:default) { nil                        }

  it_should_behave_like 'an options class method'
end
