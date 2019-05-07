require 'spec_helper'

describe 'I can create a Virtus module' do
  before do
    module Examples
      NoncoercingModule = Virtus.model do |config|
        config.coerce = false
      end

      CoercingModule = Virtus.model do |config|
        config.coerce = true

        config.coercer do |coercer|
          coercer.string.boolean_map = { 'yup' => true, 'nope' => false }
        end
      end

      StrictModule = Virtus.model do |config|
        config.strict = true
      end

      BlankModule = Virtus.model do |config|
        config.nullify_blank = true
      end

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

      class StrictModel
        include StrictModule

        attribute :stuff, Hash
        attribute :happy, Boolean, :strict => false
      end

      class BlankModel
        include BlankModule

        attribute :stuff, Hash
        attribute :happy, Boolean, :nullify_blank => false
      end
    end
  end

  specify 'including a custom module with coercion disabled' do
    user = Examples::NoncoercedUser.new(:name => :Giorgio, :happy => 'yes')

    expect(user.name).to be(:Giorgio)
    expect(user.happy).to eql('yes')
  end

  specify 'including a custom module with coercion enabled' do
    user = Examples::CoercedUser.new(:name => 'Paul', :happy => 'nope')

    expect(user.name).to eql('Paul')
    expect(user.happy).to be(false)
  end

  specify 'including a custom module with strict enabled' do
    model = Examples::StrictModel.new

    expect { model.stuff = 'foo' }.to raise_error(Virtus::CoercionError)

    model.happy = 'foo'

    expect(model.happy).to eql('foo')
  end

  specify 'including a custom module with nullify blank enabled' do
    model = Examples::BlankModel.new

    model.stuff = ''
    expect(model.stuff).to be_nil

    model.happy = 'foo'

    expect(model.happy).to eql('foo')
  end
end
