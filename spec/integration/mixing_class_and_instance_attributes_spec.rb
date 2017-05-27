require 'spec_helper'

describe 'an instance from a class with attributes' do
  before do
    module Examples
      class BaseUser
        include Virtus.model
        attribute :name, String, default: 'John'
      end
    end
  end

  let(:user) { Examples::BaseUser.new }

  specify 'can be extended with per-instance attributes' do
    user.extend(Virtus.model)
    user.attribute(:active, Virtus::Attribute::Boolean, default: true, lazy: true)

    expect(user.name).to eq 'John'
    expect(user.active).to eq true

    expect(user.to_h).to eq({:name=>"John", :active=>true})
  end

  specify 'can be extended with per-instance attributes and still allows adding attributes to the class' do
    user.extend(Virtus.model)
    user.attribute(:active, Virtus::Attribute::Boolean, default: true, lazy: true)

    Examples::BaseUser.attribute(:just_added, String, default: 'it works!', lazy: true)
    expect(user.just_added).to eq('it works!')
  end

  specify 'can be extended multiple times with per-instance attributes' do
    user.extend(Virtus.model)
    user.attribute(:active, Virtus::Attribute::Boolean, default: true, lazy: true)

    user.extend(Virtus.model) # corner case, but might happen inadvertently
    user.attribute(:age, Integer, default: 42, lazy: true)

    expect(user.name).to eq 'John'
    expect(user.active).to eq true
    expect(user.age).to eq 42

    expect(user.to_h).to eq({:name=>"John", :active=>true, :age=>42})
  end
end
