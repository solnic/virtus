require 'spec_helper'

describe Virtus::Attribute::Collection, '.writer_option_names' do
  subject { described_class.writer_option_names }

  it { should include(:member_type) }
end
