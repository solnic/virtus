require 'spec_helper'

describe Virtus::Attribute, '#public_writer?' do
  subject { object.public_writer? }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  context 'when :writer is not not specified' do
    it { should be(true) }
  end

  { :public => true, :protected => false, :private => false }.each do |value, expected|
    context "when :writer is #{value.inspect}" do
      before do
        options.update(:writer => value)
      end

      it { should be(expected) }
    end
  end
end
