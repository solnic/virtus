require 'spec_helper'

[ :clone, :dup ].each do |method|
  describe Virtus::ValueObject::InstanceMethods, "##{method}" do
    subject { object.send(method) }

    let(:object) { described_class.new }

    let(:described_class) do
      Class.new do
        include Virtus::ValueObject

        attribute :name, String
      end
    end

    it 'returns the same instance' do
      should equal(object)
    end
  end
end
