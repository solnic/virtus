require 'spec_helper'

describe 'I can create a Virtus module' do
  before do
    module Examples
      NoncoercingModule = Virtus.module { |config|
        config.coerce = false
      }

      CoercingModule = Virtus.module { |config|
        config.coerce = true

        config.coercer do |coercer|
          coercer.string.boolean_map = { 'yup' => true, 'nope' => false }
        end
      }

      class NoncoercedUser
        include NoncoercingModule

        attribute :name, String
        attribute :happy, String
      end

      class CoercedUser
        include CoercingModule

        attribute :name, String
        attribute :happy, Boolean
      end
    end
  end

  specify 'including a custom module with coercion disabled' do
    user = Examples::NoncoercedUser.new(:name => 'Giorgio', :happy => 'yes')

    expect(user.name).to eql('Giorgio')
    expect(user.happy).to eql('yes')
  end

  specify 'including a custom module with coercion enabled' do
    user = Examples::CoercedUser.new(:name => 'Paul', :happy => 'nope')

    expect(user.name).to eql('Paul')
    expect(user.happy).to be(false)
  end
end
