require 'spec_helper'

describe Casino::Focus do

  let(:model) { Model }
  let(:focus) { Casino::Focus.new(model) }

  subject { focus }

  it { subject.model.must_equal model }

  describe '#eql?' do

    let(:match) { Casino::Focus.new(model) }
    let(:no_match) { Casino::Focus.new(Class.new) }

    it "is true when compared to another focus of the same model" do
      subject.eql?(match).must_equal true
    end

    it "is false when compared to a different model focus" do
      subject.eql?(no_match).must_equal false
    end
  end

  describe '#hash' do
    it "delegates to the model hash" do
      subject.hash.must_equal model.hash
    end
  end

  describe '#build_criteria' do

    let(:conditions) do
      [ [:where, { created_at: Time.now }],
        [:and, { source: "Facebook" }] ]
    end

    let(:query) do
      Casino::Query.new(:label, conditions)
    end

    subject { focus.build_criteria(query) }

    it "produces a Mongoid::Criteria with the correct fields" do
      [ "created_at", "$and" ].each do |field|
        subject.selector.keys.must_include field
      end
    end

  end

end
