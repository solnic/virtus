require 'spec_helper'

describe Virtus::ClassMethods, '.const_missing' do
  after do
    Object.send(:remove_const, :User)
  end

  context "with an existing attribute constant which doesn't exist in the global ns" do
    before do
      class User
        include Virtus
        attribute :name, String
      end
    end

    it "should create attribute of the correct type" do
      User.attributes[:name].should be_instance_of(Virtus::Attribute::String)
    end
  end

  context "with an existing attribute constant which doesn't exist in the global ns" do
    before do
      class User
        include Virtus
        attribute :admin, Boolean
      end
    end

    it "should create attribute of the correct type" do
      User.attributes[:admin].should be_instance_of(Virtus::Attribute::Boolean)
    end
  end

  context "with an unknown constant" do
    it "should raise NameError" do
      expect {
        class User
          include Virtus
          attribute :not_gonna_work, NoSuchThing
        end
      }.to raise_error(NameError)
    end
  end
end
