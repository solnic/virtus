require 'spec_helper'

describe Virtus::Attribute::Numeric, '.min' do
  let(:object)  { Class.new(described_class) }
  let(:method)  { :min                       }
  let(:default) { nil                        }

  it_should_behave_like 'an options class method'
end
