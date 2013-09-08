shared_examples_for 'an options class method' do
  context 'with no argument' do
    subject { object.send(method) }

    it { should be(default) }
  end

  context 'with a default value' do
    subject { object.send(method, value) }

    let(:value) { double('value') }

    it { should equal(object) }

    it 'sets the default value for the class method' do
      expect { subject }.to change { object.send(method) }.from(default).to(value)
    end
  end
end
