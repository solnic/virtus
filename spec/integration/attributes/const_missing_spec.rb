require 'spec_helper'

class User; end

describe User, '.const_missing' do
  context "with an existing attribute constant which doesn't exist in the global ns" do
    before do
      class User
        include Virtus
        attribute :name, String
      end
    end

    it "should create attribute of the correct type" do
      User.attributes[:name].should be_instance_of(Virtus::Attributes::String)
    end
  end

  context "with an existing attribute constant which doesn't exist in the global ns" do
    before do
      lambda {
        class User
          include Virtus
          attribute :admin, Boolean
        end
      }.should_not raise_error(NameError)
    end

    it "should create attribute of the correct type" do
      User.attributes[:admin].should be_instance_of(Virtus::Attributes::Boolean)
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
