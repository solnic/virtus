require 'spec_helper'

describe Virtus::Attribute, '#coerce' do
  subject { object.coerce(value) }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }
  let(:value)           { mock('value', :class => value_class)                             }
  let(:value_class)     { stub('value_class')                                              }
  let(:coercer)         { mock('coercer', :public_send => coerced)                         }
  let(:coerced)         { stub('coerced')                                                  }

  before do
    Virtus::Coercion.stub(:[]).with(value_class).and_return(coercer)
  end

  it { should be(coerced) }

  it 'asks for a coercer object' do
    Virtus::Coercion.should_receive(:[]).with(value_class)
    subject
  end

  it 'asks the coercer to coerce the value' do
    coercer.should_receive(:public_send).with(coercion_method, value)
    subject
  end
end
