require 'spec_helper'

describe Virtus::Attribute, '#writer_visibility' do
  subject { object.writer_visibility }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  context 'when not specified' do
    it { should be(:public) }
  end

  context 'when specified' do
    let(:writer) { stub('writer') }

    before do
      options.update(:writer => writer)
    end

    it { should be(writer) }
  end
end
