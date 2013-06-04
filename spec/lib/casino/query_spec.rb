require 'spec_helper'

describe Casino::Query do

  let(:label) { "women's boots" }
  let(:criteria) { [ /page_gender=f/i, /offer_cohort=boots/i ] }
  let(:query) { Casino::Query.new(label, [], *criteria) }

  subject { query }

  it { subject.label.must_equal label }
  it { subject.criteria.must_equal criteria }
  it { subject.conditions.must_equal [] }

  describe '#merge' do

    let(:field) { :created_at }
    let(:queries) { :method_name }
    let(:and_approach) { { operator: :and } }

    let(:dimension) do
      Casino::Dimension.new("Date", field, queries, and_approach)
    end

    let(:conditions) do
      query.criteria.map do |condition|
        [ :and, { dimension.field => condition } ]
      end
    end

    subject { query.merge(dimension) }

    it "merges the dimension data in" do
      subject.conditions.must_equal conditions
    end

    it "produces a different object" do
      subject.wont_equal query
    end

  end
end
