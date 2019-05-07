require 'spec_helper'

describe Virtus, '#[]=' do
  subject { object[:test] = 'foo' }

  let(:model) do
    Class.new do
      include Virtus

      attribute :test, String
    end
  end

  let(:object) { model.new }

  specify do
    expect { subject }.to change { object.test }.from(nil).to('foo')
  end
end
