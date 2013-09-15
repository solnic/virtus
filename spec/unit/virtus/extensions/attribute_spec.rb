require 'spec_helper'

describe Virtus, '#attribute' do
  subject { object.attribute(name, type, options) }

  let(:name)    { :test }
  let(:options) { {} }

  context 'with a class' do
    let(:object) { Class.new { include Virtus } }

    context 'when type is Boolean' do
      let(:type) { Virtus::Attribute::Boolean }

      it { should be(object) }

      its(:instance_methods) { should include(:test) }
      its(:instance_methods) { should include(:test?) }
    end
  end
end
