require 'spec_helper'

describe Casino::Dimension do

  let(:label) { "Date" }
  let(:field) { :created_at }
  let(:queries) { :method_name }
  let(:and_approach) { { operator: :and } }
  let(:where_approach) { { operator: :where } }

  let(:dimension) do
    Casino::Dimension.new(label, field, queries, and_approach)
  end

  subject { dimension }

  it { subject.label.must_equal label }
  it { subject.queries.must_equal queries }
  it { subject.approach.must_equal and_approach }
  it { subject.field.must_equal field }

  it 'defaults #approach to operator: :where' do
    dimension = Casino::Dimension.new(label, field, queries)
    dimension.approach.must_equal where_approach
  end

end
