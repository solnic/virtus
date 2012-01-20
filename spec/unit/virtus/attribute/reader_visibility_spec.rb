require 'spec_helper'

describe Virtus::Attribute, '#reader_visibility' do
  subject { object.reader_visibility }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  context 'when not specified' do
    it { should be(:public) }
  end

  context 'when specified' do
    let(:reader) { stub('reader') }

    before do
      options.update(:reader => reader)
    end

    it { should be(reader) }
  end
end
