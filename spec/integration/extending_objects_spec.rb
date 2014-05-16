require 'spec_helper'

describe 'I can extend objects' do
  before do
    module Examples
      class User; end

      class Admin; end
    end
  end

  specify 'defining attributes on an object' do
    attributes = { :name => 'John', :age => 29 }

    admin = Examples::Admin.new
    admin.extend(Virtus)

    admin.attribute :name, String
    admin.attribute :age,  Integer

    admin.name = 'John'
    admin.age  = 29

    expect(admin.name).to eql('John')
    expect(admin.age).to eql(29)

    expect(admin.attributes).to eql(attributes)

    new_attributes   = { :name => 'Jane', :age => 28 }
    admin.attributes = new_attributes

    expect(admin.name).to eql('Jane')
    expect(admin.age).to eql(28)
  end
end
