require 'spec_helper'

describe Virtus::Attribute, '#options' do
  subject { object.options }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  it { should be_instance_of(Hash) }

  it { should eql(options.merge(:accessor => :public)) }
end
