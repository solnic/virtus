require 'spec_helper'

describe Virtus::DescendantsTracker, '#descendants' do
  subject { object.descendants }

  let(:described_class) { Class.new { extend Virtus::DescendantsTracker } }
  let(:object)          { described_class                                 }

  context 'when there are no descendants' do
    it_should_behave_like 'an idempotent method'

    it { should be_empty }
  end

  context 'when there are descendants' do
    let!(:descendant) { Class.new(object) }  # trigger the class inhertance

    it_should_behave_like 'an idempotent method'

    it { should eql([ descendant ]) }
  end
end
