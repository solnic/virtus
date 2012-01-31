require 'spec_helper'

describe Virtus::Attribute, '.coercion_method' do
  let(:object)  { Class.new(described_class) }
  let(:method)  { :coercion_method           }
  let(:default) { nil                        }

  it_should_behave_like 'an options class method'
end
