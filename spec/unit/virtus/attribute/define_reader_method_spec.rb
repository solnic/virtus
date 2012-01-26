require 'spec_helper'

describe Virtus::Attribute, '#define_reader_method' do
  subject { object.define_reader_method(mod) }

  let(:object)            { described_class.new(:name, options)                              }
  let(:options)           { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)         { stub('primitive')                                                }
  let(:coercion_method)   { stub('coercion_method')                                          }
  let(:reader_visibility) { stub('reader_visibility')                                        }
  let(:mod)               { mock('mod')                                                      }

  before do
    options.update(:reader => reader_visibility)
    mod.stub(:define_reader_method).with(object, :name, reader_visibility)
  end

  it { should be(object) }

  it 'calls #define_reader_method on the module' do
    mod.should_receive(:define_reader_method).with(object, :name, reader_visibility)
    subject
  end
end
