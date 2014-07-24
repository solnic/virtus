shared_examples_for 'a #freeze method' do
  let(:sample_exception) do
    begin
      object.dup.freeze.instance_variable_set(:@foo, :bar)
    rescue => exception
      exception
    end
  end

  let(:expected_exception_class) do
    # Ruby 1.8 blows up with TypeError Ruby 1.9 with RuntimeError
    sample_exception.class
  end

  let(:expected_exception_message) do
    # Ruby 1.8 blows up with a different message than Ruby 1.9
    sample_exception.message
  end

  it_should_behave_like 'an idempotent method'

  it 'returns object' do
    should be(object)
  end

  it 'prevents future modifications' do
    subject
    expectation = raise_error(expected_exception_class,expected_exception_message)
    expect { object.instance_variable_set(:@foo, :bar) }.to(expectation)
  end

  its(:frozen?) { should be(true) }

  it 'allows to access attribute' do
    expect(subject.name).to eql('John')
  end
end
