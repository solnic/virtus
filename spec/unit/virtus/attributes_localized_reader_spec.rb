require 'spec_helper'

describe Virtus, '#attributes :localized => true' do

  shared_examples_for 'attribute hash' do
    it 'includes all attributes' do
      I18n.locale = :en
      subject.attributes = { :loc => 'Hello!' }

      I18n.locale = :es
      subject.attributes = { :loc => 'Hola!' }

      I18n.locale = :de
      subject.attributes = { :loc => 'Guten Tag!' }
      expect(subject.instance_variable_get("@loc")).to eql({"en" => 'Hello!', "es" => 'Hola!', "de" => 'Guten Tag!'})

      expect(subject.attributes).to eql(:loc => 'Guten Tag!')
      I18n.locale = :en
      expect(subject.attributes).to eql(:loc => 'Hello!')
      I18n.locale = :es
      expect(subject.attributes).to eql(:loc => 'Hola!')
    end
  end

  context 'with a class' do
    let(:model) {
      Class.new {
        include Virtus

        attribute :loc,      String, :localized => true
      }
    }

    it_behaves_like 'attribute hash' do
      subject { model.new }
    end
  end

  context 'with an instance' do
    subject { model.new }

    let(:model) { Class.new }

    before do
      subject.extend(Virtus)
      subject.attribute :loc,      String, :localized => true
    end

    it_behaves_like 'attribute hash'
  end
end

