require 'spec_helper'

describe "Adding attribute called 'attributes'" do

  context "when mass assignment is disabled" do
    before do
      module Examples
        class User
          include Virtus.model(mass_assignment: false)

          attribute :attributes
        end
      end
    end

    it "allows model to use `attributes` attribute" do
      user = Examples::User.new
      expect(user.attributes).to eq(nil)
      user.attributes = "attributes string"
      expect(user.attributes).to eq("attributes string")
    end

    it "doesn't accept `attributes` key in initializer" do
      user = Examples::User.new(attributes: 'attributes string')
      expect(user.attributes).to eq(nil)
    end
  end
end
