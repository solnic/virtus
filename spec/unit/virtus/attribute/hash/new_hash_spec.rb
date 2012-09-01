require 'spec_helper'

describe Virtus::Attribute::Hash, '#new_hash' do
  subject { object.new_hash }

  let(:options) { {} }
  let(:object)  { Virtus::Attribute::Hash.new('stuff', options) }

  it { should be_instance_of(::Hash) }


  context '`:key_type` and `:value_type` options' do
    before do
      subject[:one] = 1
      subject[2]    = '2.0'
    end

    context 'are undefined' do
      it 'should not coerce keys on assigning' do
        subject.keys.should =~ [:one, 2]
      end

      it 'should not coerce values on assigning' do
        subject.values.should =~ [1, '2.0']
      end
    end

    context 'are defined' do
      let(:options) {{
        :key_type   => String,
        :value_type => Integer
      }}

      it 'should coerce keys on assigning' do
        subject.keys.should =~ ['one', '2']
      end

      it 'should coerce values on assigning' do
        subject.values.should =~ [1, 2]
      end
    end
  end
end
