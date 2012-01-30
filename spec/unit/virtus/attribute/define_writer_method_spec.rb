require 'spec_helper'

describe Virtus::Attribute, '#define_writer_method' do
  subject { object.define_writer_method(mod) }

  let(:object)            { described_class.new(:name, options)                              }
  let(:options)           { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)         { stub('primitive')                                                }
  let(:coercion_method)   { stub('coercion_method')                                          }
  let(:writer_visibility) { stub('writer_visibility')                                        }
  let(:mod)               { mock('mod')                                                      }

  before do
    options.update(:writer => writer_visibility)
    mod.stub(:define_writer_method).with(object, :name=, writer_visibility)
  end

  it { should be(object) }

  it 'calls #define_writer_method on the module' do
    mod.should_receive(:define_writer_method).with(object, :name=, writer_visibility)
    subject
  end
end
