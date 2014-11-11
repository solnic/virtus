require 'spec_helper'

describe 'sending a Hash to new' do

  class InitializeTest
    include Subvirtus

    attribute :string_1,  String
    attribute :integer_1, Integer
    attribute :boolean_1, Boolean
    attribute :float_1,   Float
    attribute :fixnum_1,  Fixnum
    attribute :bignum_1,  Bignum

    attribute :string_2,  String
    attribute :integer_2, Integer
    attribute :boolean_2, Boolean
    attribute :float_2,   Float
    attribute :fixnum_2,  Fixnum
    attribute :bignum_2,  Bignum
  end

  let( :test ) { InitializeTest.new( {  string_1:  'subvirtus',
                                        integer_1: 12,
                                        boolean_1: true,
                                        float_1:   13.45,
                                        fixnum_1:  14,
                                        bignum_1:  9999999999899999999 * 9999999999899999999,

                                        string_2:  'david',
                                        integer_2: 16,
                                        boolean_2: false,
                                        float_2:   17.45,
                                        fixnum_2:  18,
                                        bignum_2:  9999999999999999999 * 9999999999999999999 } ) }

  {
    string_1:  { type: String,     value: 'subvirtus' },
    integer_1: { type: Integer,    value: 12          },
    boolean_1: { type: TrueClass,  value: true        },
    float_1:   { type: Float,      value: 13.45       },
    fixnum_1:  { type: Fixnum,     value: 14          },
    bignum_1:  { type: Bignum,     value: 9999999999899999999 * 9999999999899999999 },

    string_2:  { type: String,     value: 'david'     },
    integer_2: { type: Integer,    value: 16          },
    boolean_2: { type: FalseClass, value: false       },
    float_2:   { type: Float,      value: 17.45       },
    fixnum_2:  { type: Fixnum,     value: 18          },
    bignum_2:  { type: Bignum,     value: 9999999999999999999 * 9999999999999999999 }
  }.each do |attr, value|
    it "responds to ##{ attr }" do
      expect( test ).to respond_to( attr )
    end
    it "responds to ##{ attr }=" do
      expect( test ).to respond_to( "#{ attr }=" )
    end
    it "has the right value for ##{ attr }" do
      expect( test.send attr ).to eq( value[ :value ] )
    end
    it "has the right type for ##{ attr }" do
      expect( test.send( attr ).is_a? value[ :type ] ).to be_truthy
    end
  end
end