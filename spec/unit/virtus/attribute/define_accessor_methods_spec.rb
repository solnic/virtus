require 'spec_helper'

describe Virtus::Attribute, '#define_accessor_methods' do
  subject { object.define_accessor_methods(mod) }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }
  let(:mod)             { stub('mod')                                                      }

  before do
    object.stub(:define_reader_method).with(mod)
    object.stub(:define_writer_method).with(mod)
  end

  it 'delegates to #define_reader_method' do
    object.should_receive(:define_reader_method).with(mod)
    subject
  end

  it 'delegates to #define_writer_method' do
    object.should_receive(:define_writer_method).with(mod)
    subject
  end
end
