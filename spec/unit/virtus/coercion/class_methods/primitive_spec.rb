require 'spec_helper'

describe Virtus::Coercion, '.primitive' do
  Virtus::Coercion.descendants.each do |descendant|
    subject { descendant.primitive }

    let(:primitive) { Object.const_get(descendant.name.split('::').last.to_sym) }

    describe "#{descendant}.primitive" do
      it { should be(primitive) }
    end
  end
end
