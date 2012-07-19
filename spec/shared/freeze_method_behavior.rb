shared_examples_for 'a #freeze method' do
  it_should_behave_like 'an idempotent method'

  it 'returns object' do
    should be(object)
  end

  it 'prevents future modifications' do
    subject
    expect { object.instance_variable_set(:@foo,:bar) }.to raise_error(RuntimeError,"can't modify frozen #{object.class.inspect}")
  end

  its(:frozen?) { should be(true) }

  it 'allows to access attribute' do
    subject.name.should eql('John')
  end
end
