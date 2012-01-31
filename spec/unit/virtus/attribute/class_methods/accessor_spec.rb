require 'spec_helper'

describe Virtus::Attribute, '.accessor' do
  let(:object)          { Class.new(described_class)                                       }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }
  let(:method)          { :accessor                                                        }
  let(:default)         { :public                                                          }

  it_should_behave_like 'an options class method'
end
