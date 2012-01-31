require 'spec_helper'

describe Virtus::Attribute, '.primitive' do
  let(:object)  { Class.new(described_class) }
  let(:method)  { :primitive                 }
  let(:default) { nil                        }

  it_should_behave_like 'an options class method'
end
