require 'spec_helper'

describe Virtus, '#[]=' do
  subject { object[:test] = 'foo' }

  let(:model) {
    Class.new {
      include Virtus

      attribute :test, String
    }
  }

  let(:object) { model.new }

  specify do
    expect { subject }.to change { object.test }.from(nil).to('foo')
  end
end
