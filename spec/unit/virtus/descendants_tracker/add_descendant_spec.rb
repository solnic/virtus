require 'spec_helper'

describe Virtus::DescendantsTracker, '#add_descendant' do
  subject { object.add_descendant(descendant) }

  let(:described_class) { Class.new { extend Virtus::DescendantsTracker } }
  let(:object)          { Class.new(described_class)                      }
  let(:descendant)      { Class.new                                       }

  it { should equal(object) }

  it 'prepends the class to the descendants' do
    object.descendants << original = Class.new
    expect { subject }.to change { object.descendants.dup }.
      from([ original ]).
      to([ descendant, original ])
  end

  it 'prepends the class to the superclass descendants' do
    expect { subject }.to change { object.superclass.descendants.dup }.
      from([ object ]).
      to([ descendant, object ])
  end
end
