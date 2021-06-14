require 'spec_helper'

describe 'custom attributes' do

  before do
    module Examples
      class ExternalObjectId
        attr_reader :oid
        include Equalizer.new(:oid)
        def initialize(oid)
          @oid = oid
        end

        def self.from_string(oid)
          new(oid)
        end
      end

      class ExternalObjectIdAttribute < Virtus::Attribute
        primitive ExternalObjectId

        def coerce(input)
          ExternalObjectId.from_string(input.to_s)
        end
      end

      class NoisyString < Virtus::Attribute
        lazy true

        def coerce(input)
          input.to_s.upcase
        end
      end

      class RegularExpression < Virtus::Attribute
        primitive Regexp
      end

      class User
        include Virtus

        attribute :name, String
        attribute :scream, NoisyString
        attribute :expression, RegularExpression
        attribute :id, ExternalObjectId
        attribute :other_ids, Array[ExternalObjectId]
        attribute :alias_ids, Hash[ExternalObjectId => ExternalObjectId]
      end
    end
  end

  subject { Examples::User.new }

  specify 'allows you to define custom attributes' do
    regexp = /awesome/
    subject.expression = regexp
    expect(subject.expression).to eq(regexp)
  end

  specify 'allows you to define coercion methods' do
    subject.scream = 'welcome'
    expect(subject.scream).to eq('WELCOME')
  end

  context 'with a primitive defined' do
    specify 'allows you to define coercion methods' do
      subject.id = '53e51e803f30e1037e0008ac'
      expect(subject.id).to eq(
        Examples::ExternalObjectId.from_string('53e51e803f30e1037e0008ac')
      )
    end

    context 'when used as an array member' do
      specify 'coerces array members' do
        subject.other_ids = [
          '53e51eee3f30e1037e002c01', '53e51eee3f30e1037e002c02'
        ]

        expect(subject.other_ids).to eq([
          Examples::ExternalObjectId.from_string('53e51eee3f30e1037e002c01'),
          Examples::ExternalObjectId.from_string('53e51eee3f30e1037e002c02')
        ])
      end
    end

    context 'when used as a Hash key and/or value members' do
      specify 'coerces key and value members' do
        subject.alias_ids = { :one => 'two', 'three' => :four }
        expect(subject.alias_ids).to eq({ 
          Examples::ExternalObjectId.from_string('one') => Examples::ExternalObjectId.from_string('two'),
          Examples::ExternalObjectId.from_string('three') => Examples::ExternalObjectId.from_string('four')
        })
      end
    end
  end

end
