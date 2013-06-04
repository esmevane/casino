# If it's a regular expression, match with =~
# If it's a hash, recurse over the hash with the document
# If it is in the following directives, do the directive operation:
#   * $gt evaluates with >
#   * $gte evaluates with >=
#   * $lt evalutes with <
#   * $lte evaluates with <=
#   * $in evaluates with Array#include?
#   * $and evalutes as a list with each element of the list
#     representing a new level of Match::Base with its own
#     key
# If it's a string/integer, match with ==

describe Casino::Intersection::Match::Base do

  let(:base_class) { Casino::Intersection::Match::Base }
  let(:document) { Model.new(created_at: 3.days.ago) }
  let(:key) { 'created_at' }
  let(:criteria) { Model.gt(created_at: 4.days.ago) }
  let(:selector) { criteria.selector }
  let(:value) { document.created_at }
  let(:base) { base_class.new(document, key, selector, value) }
  let(:source) { "Facebook" }
  let(:label) { [source] }
  let(:intersection) { Casino::Intersection.new(label, criteria) }

  describe 'when the document has an equivalent value' do
    let(:model) { Model.new(source: source) }
    let(:criteria) { Model.where(source: source) }
    subject { intersection.match?(model) }
    it { subject.must_equal true }
  end

  describe 'when the document has a regular expression' do
    let(:model) { Model.new(source: source) }
    let(:criteria) { Model.where(source: /Face/i) }
    subject { intersection.match?(model) }
    it { subject.must_equal true }
  end

  describe 'directives' do

    describe '$and' do
      let(:model) { Model.new(source: "Facebook", created_at: 3.days.ago) }

      let(:criteria) do
        Model.and(:created_at.gt => 4.days.ago).
          and(source: "Facebook")
      end

      subject { intersection.match?(model) }
      it { subject.must_equal true }
    end

    describe '$in' do
      let(:model) { Model.new(source: "Facebook") }
      let(:criteria) { Model.in(source: "Facebook") }
      subject { intersection.match?(model) }
      it { subject.must_equal true }
    end

    describe '$gt' do
      let(:model) { Model.new(created_at: 3.days.ago) }
      let(:criteria) { Model.gt(created_at: 4.days.ago) }
      subject { intersection.match?(model) }
      it { subject.must_equal true }
    end

    describe '$lt' do
      let(:model) { Model.new(created_at: 4.days.ago) }
      let(:criteria) { Model.lt(created_at: 3.days.ago) }
      subject { intersection.match?(model) }
      it { subject.must_equal true }
    end

    describe '$gte' do
      let(:model) { Model.new(created_at: 3.days.ago) }
      let(:criteria) { Model.gte(created_at: 3.days.ago) }
      subject { intersection.match?(model) }
      it { subject.must_equal true }
    end

    describe '$lte' do
      let(:three_days_ago) { 3.days.ago }
      let(:model) { Model.new(created_at: three_days_ago) }
      let(:criteria) { Model.lte(created_at: three_days_ago) }
      subject { intersection.match?(model) }
      it { subject.must_equal true }
    end

  end

  describe 'creating a new matcher base' do

    describe '#document' do
      subject { base.document }
      it { subject.must_equal document }
    end

    describe '#key' do
      subject { base.key }
      it { subject.must_equal key }
    end

    describe '#selector' do
      subject { base.selector }
      it { subject.must_equal selector }
    end

    describe '#field' do
      subject { base.field }
      it { subject.must_equal selector[key] }
    end

    describe '#value' do
      subject { base.value }
      it { subject.must_equal document.send(key) }
    end

  end

  describe '#evaluate' do
    it 'calls #evaluate on the given #matcher' do
      matcher = MiniTest::Mock.new
      matcher.expect :evaluate, nil
      base.stub(:matcher, matcher) do
        base.evaluate
      end
      matcher.verify
    end
  end

  describe 'interfaces to matcher classes' do

    describe '#matcher_for' do
      it "creates a matcher for the given class name" do
        matcher = base.matcher_for(:equivalence)
        matcher.must_be_instance_of Casino::Intersection::Match::Equivalence
      end
    end

    describe '#match_arguments' do
      let(:arguments) { [base.key, base.value, base.document, base.field] }
      subject { base.match_arguments }
      it { subject.must_equal arguments }
    end

    describe '#matcher' do
      it "finds the first eligible matcher" do
        eligible_matcher = OpenStruct.new(eligible?: true)
        base.stub(:matchers, [eligible_matcher]) do
          base.matcher.must_equal eligible_matcher
        end
      end
    end

  end

end
