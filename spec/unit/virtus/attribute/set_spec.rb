require 'spec_helper'

describe Virtus::Attribute, '#set' do
  subject { object.set(instance, value) }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }
  let(:instance)        { Object.new                                                       }
  let(:value)           { stub('value')                                                    }
  let(:coerced)         { stub('coerced')                                                  }

  before do
    object.stub(:coerce).with(value).and_return(coerced)
    object.stub(:set!).with(instance, coerced).and_return(object)
  end

  it { should be(object) }

  it 'coerces the value' do
    object.should_receive(:coerce).with(value)
    subject
  end

  it 'sets the instance variable to the coerced value' do
    object.should_receive(:set!).with(instance, coerced)
    subject
  end
end

describe Virtus::Attribute, '#set!' do
  subject { object.set!(instance, value) }

  let(:object)          { described_class.new(:name, options)                              }
  let(:options)         { { :primitive => primitive, :coercion_method => coercion_method } }
  let(:primitive)       { stub('primitive')                                                }
  let(:coercion_method) { stub('coercion_method')                                          }
  let(:instance)        { Object.new                                                       }
  let(:value)           { stub('value')                                                    }

  it { should be(object) }

  it 'sets the instance variable to the value' do
    instance.instance_variable_get(:@name).should be_nil
    subject
    instance.instance_variable_get(:@name).should be(value)
  end
end
