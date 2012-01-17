require 'spec_helper'

describe Virtus::Attribute, '.accessor' do
  let(:object)          { Class.new(described_class)                                       }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }

  context 'with no argument' do
    subject { object.accessor } 

    it { should be(:public) }
  end

  context 'with the default accessor' do
    subject { object.accessor(value) }

    let(:value) { stub('value') }

    it { should equal(object) } 

    it 'sets the accessor default for the class' do                                        
      expect { subject }.to change { object.accessor }.from(nil).to(value)                 
    end
  end
end
