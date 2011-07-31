require 'spec_helper'

describe Virtus::Coercion::String, '.to_class' do
  subject { object.to_class(string) }

  let(:object) { described_class }

  context "with a String" do
    let(:string) { 'String' }

    it { should be(String) }
  end
end
