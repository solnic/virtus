require 'virtus'


describe "nested" do
  class EmailAddress
    include Virtus.value_object
    values do
      attribute :address, String, :coercer => lambda{|add| add.downcase }
    end
  end

  def EmailAddress(string)
    EmailAddress.new :address => string
  end

  class User
    include Virtus.model
    attribute :email, EmailAddress, :coercer => lambda {|add| new_address(add) }
  end

  let(:doe) { EmailAddress.new(:address => "john.doe@example.com") }

  it "casts an email address" do
    expect(EmailAddress("John.Doe@example.com")).to eq doe
  end

  it "accepts an email hash" do
    user = User.new :email => { :address => "john.doe@example.com" }
    expect(user.email).to eq doe
  end

  it "coreces an embedded string" do
    user = User.new :email => "john.doe@example.com"
    expect(user.email).to eq doe
  end

end
