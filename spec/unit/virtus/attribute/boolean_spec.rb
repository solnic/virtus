require 'spec_helper'

describe Virtus::Attribute::Boolean do
  describe 'accessor names' do
    let(:model) do
      Class.new do
        include Virtus

        attribute :is_admin, Virtus::Attribute::Boolean
      end
    end

    let(:object) { model.new(:is_admin => true) }

    it 'uses standard boolean reader naming conventions' do
      object.is_admin?.should be_true
    end
  end
end
