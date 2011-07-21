require 'spec_helper'

%w[ to_string to_date to_datetime to_time to_array to_hash to_boolean to_i to_f to_d ].each do |name|
  describe Virtus::Typecast::Object, ".#{name}" do
    subject { object.send(name, value) }

    let(:object) { described_class }
    let(:value)  { Object.new      }

    it { should equal(value) }
  end
end
