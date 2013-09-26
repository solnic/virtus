require 'virtus'

describe 'Injectible coercer' do
  before do
    module Examples
      class EmailAddress
        include Virtus.value_object

        values do
          attribute :address, String, :coercer => lambda { |add| add.downcase }
        end

        def self.coerce(input)
          if input.is_a?(String)
            new(:address => input)
          else
            new(input)
          end
        end
      end

      class User
        include Virtus.model

        attribute :email, EmailAddress,
          :coercer => lambda { |input| Examples::EmailAddress.coerce(input) }
      end
    end
  end

  after do
    Examples.send(:remove_const, :EmailAddress)
    Examples.send(:remove_const, :User)
  end

  let(:doe) { Examples::EmailAddress.new(:address => 'john.doe@example.com') }

  it 'accepts an email hash' do
    user = Examples::User.new :email => { :address => 'John.Doe@Example.Com' }
    expect(user.email).to eq(doe)
  end

  it 'coerces an embedded string' do
    user = Examples::User.new :email => 'John.Doe@Example.Com'
    expect(user.email).to eq(doe)
  end

end
