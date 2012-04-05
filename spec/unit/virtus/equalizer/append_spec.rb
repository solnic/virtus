require 'spec_helper'

describe Virtus::Equalizer, '#<<' do
  subject { object << :last_name }

  let(:object)     { described_class.new(name, attributes) }
  let(:name)       { 'User'                                }
  let(:attributes) { [ :first_name ].freeze                }
  let(:first_name) { 'John'                                }
  let(:last_name)  { 'Doe'                                 }

  let(:klass) do
    klass = Class.new { attr_accessor :first_name, :last_name }
    klass.send(:include, object)
    klass
  end

  let(:instance) do
    klass.new.tap do |instance|
      instance.first_name = first_name
      instance.last_name  = last_name
    end
  end

  describe '#eql?' do
    context 'when the objects are similar' do
      let(:other) { instance.dup }

      it 'adds a key to the comparison' do
        expect { subject }.to_not change { instance.eql?(other) }.from(true)
      end
    end

    context 'when the objects are different' do
      let(:other) { instance.dup }

      before do
        other.last_name = 'Smith'
      end

      it 'adds a key to the comparison' do
        expect { subject }.to change { instance.eql?(other) }.
          from(true).to(false)
      end
    end
  end

  describe '#==' do
    context 'when the objects are similar' do
      let(:other) { instance.dup }

      it 'adds a key to the comparison' do
        expect { subject }.to_not change { instance == other }.from(true)
      end
    end

    context 'when the objects are different' do
      let(:other) { instance.dup }

      before do
        other.last_name = 'Smith'
      end

      it 'adds a key to the comparison' do
        expect { subject }.to change { instance == other }.
          from(true).to(false)
      end
    end
  end

  it 'adds a new to #hash' do
    expect { subject }.to change(instance, :hash).
      from(klass.hash ^ first_name.hash).
      to(klass.hash ^ first_name.hash ^ last_name.hash)
  end

  it 'adds a new to #inspect' do
    expect { subject }.to change(instance, :inspect).
      from('#<User first_name="John">').
      to('#<User first_name="John" last_name="Doe">')
  end
end
