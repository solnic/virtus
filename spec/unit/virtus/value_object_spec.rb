require 'spec_helper'

describe Virtus::ValueObject do
  shared_examples_for 'a valid value object' do
    subject { model.new(attributes) }

    let(:attributes) { Hash[:id => 1, :name => 'Jane Doe'] }

    describe '#id' do
      subject { super().id }
      it { is_expected.to be(1) }
    end

    describe '#name' do
      subject { super().name }
      it { is_expected.to eql('Jane Doe') }
    end

    it 'sets private writers' do
      expect(subject.class.attribute_set[:id]).to_not be_public_writer
      expect(subject.class.attribute_set[:name]).to_not be_public_writer
    end

    it 'disallows cloning' do
      expect(subject.clone).to be(subject)
    end

    it 'defines #eql?' do
      expect(subject).to eql(subject.class.new(attributes))
    end

    it 'defines #==' do
      expect(subject == subject.class.new(attributes)).to be(true)
    end

    it 'defines #hash' do
      expect(subject.hash).to eql(subject.class.new(attributes).hash)
    end

    it 'defines #inspect' do
      expect(subject.inspect).to eql(
        %(#<Model #{attributes.map { |k, v| "#{k}=#{v.inspect}" }.join(' ')}>)
      )
    end

    it 'allows to construct new values using #with' do
      new_instance = subject.with(:name => "John Doe")
      expect(new_instance.id).to eql(subject.id)
      expect(new_instance.name).to eql("John Doe")
    end
  end

  shared_examples_for 'a valid value object with mass-assignment turned on' do
    subject { model.new }

    it 'disallows mass-assignment' do
      expect(subject.private_methods).to include(:attributes=)
    end
  end

  context 'using new values {} block' do
    let(:model) {
      model = Virtus.value_object(:coerce => false, :mass_assignment => mass_assignment)

      Class.new {
        include model

        def self.name
          'Model'
        end

        values do
          attribute :id,   Integer
          attribute :name, String
        end
      }
    }

    context 'without mass-assignment' do
      let(:mass_assignment) { false }

      it_behaves_like 'a valid value object'
    end

    context 'with mass-assignment' do
      let(:mass_assignment) { true }

      it_behaves_like 'a valid value object'
      it_behaves_like 'a valid value object with mass-assignment turned on'

      context 'with a model subclass' do
        let(:subclass) {
          Class.new(model) {
            values do
              attribute :email, String
            end
          }
        }

        it_behaves_like 'a valid value object' do
          subject { subclass.new(attributes) }

          let(:attributes) { Hash[:id => 1, :name => 'Jane Doe', :email => 'jane@doe.com'] }

          describe '#email' do
            subject { super().email }
            it { is_expected.to eql('jane@doe.com') }
          end

          it 'sets private writers for additional values' do
            expect(subclass.attribute_set[:email]).to_not be_public_writer
          end

          it 'defines valid #== for a subclass' do
            expect(subject == subject.class.new(attributes.merge(:id => 2))).to be(false)
          end
        end
      end
    end
  end

  context 'using deprecated inclusion' do
    let(:model) {
      Class.new {
        include Virtus::ValueObject

        def self.name
          'Model'
        end

        attribute :id,   Integer
        attribute :name, String
      }
    }

    it_behaves_like 'a valid value object'
  end
end
