describe Casino::Intersection::Match::Equivalence do

  let(:klass) { Casino::Intersection::Match::Equivalence }
  let(:source) { "Facebook" }
  let(:document) { Model.new(source: source) }
  let(:criteria) { Model.where(source: source) }
  let(:selector) { criteria.selector }
  let(:key) { 'source' }
  let(:field) { selector[key] }
  let(:value) { document.send(key) }
  let(:equivalence) { klass.new(key, field, document, source) }

  describe '#evaluate' do
    describe 'when values match' do
      subject { equivalence.evaluate }
      it { subject.must_equal true }
    end

    describe 'when values do not match' do
      let(:inequivalence) { klass.new(key, field, document, "Google") }
      subject { inequivalence.evaluate }
      it { subject.must_equal false }
    end
  end

end