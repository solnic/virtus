require 'spec_helper'

describe Virtus::Attribute, '#name' do
  subject { object.name }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { double('primitive')                                                }
  let(:coercion_method) { double('coercion_method')                                          }

  it { should be(:name) }
end
