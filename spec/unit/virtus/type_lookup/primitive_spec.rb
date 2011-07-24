require 'spec_helper'

describe Virtus::TypeLookup, '#primitive' do
  subject { object.primitive }

  let(:object) { Class.new { extend Virtus::TypeLookup } }

  specify { expect { subject }.to raise_error(NotImplementedError, "#{object}.primitive must be implemented") }
end
