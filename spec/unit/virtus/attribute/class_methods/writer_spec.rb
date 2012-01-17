require 'spec_helper'

describe Virtus::Attribute, '.writer' do
  let(:object)  { Class.new(described_class) }
  let(:method)  { :writer                    }
  let(:default) { nil                        }

  it_should_behave_like 'an options class method'
end
