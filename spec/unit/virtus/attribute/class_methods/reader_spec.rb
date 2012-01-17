require 'spec_helper'

describe Virtus::Attribute, '.reader' do
  let(:object)  { Class.new(described_class) }
  let(:method)  { :reader                    }
  let(:default) { nil                        }

  it_should_behave_like 'an options class method'
end
