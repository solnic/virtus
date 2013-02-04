require 'spec_helper'

describe Virtus::Attribute::Hash, '.merge_options' do
  subject { described_class.writer_option_names }

  it { should include(:key_type) }
  it { should include(:value_type) }
end
