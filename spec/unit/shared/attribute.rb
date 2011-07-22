shared_examples_for "Attribute" do
  it_behaves_like 'Attribute.options'
  it_behaves_like 'Attribute.accept_options'
  it_behaves_like 'Attribute.accepted_options'
  it_behaves_like 'Attribute.primitive?'
  it_behaves_like 'Attribute#set'
  it_behaves_like 'Attribute#get'
  it_behaves_like 'Attribute#complex?'
end
