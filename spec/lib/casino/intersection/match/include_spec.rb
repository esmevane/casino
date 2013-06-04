describe Casino::Intersection::Match::Include do

  let(:system) { Casino::Intersection::Match::Include }

  describe '#eligible?' do
    describe 'when the key is $in' do
      let(:matcher) { system.new('$in', '', '', '') }
      subject { matcher.eligible? }
      it { subject.must_equal true }
    end
  end

  describe '#evaluate' do
    describe 'when the value is within the field' do
      let(:matcher) { system.new('$in', 1, '', [1, 2, 3, 4]) }
      subject { matcher.evaluate }
      it { subject.must_equal true }
    end

    describe 'when the value is not within the field' do
      let(:matcher) { system.new('$in', 1, '', [2, 3, 4]) }
      subject { matcher.evaluate }
      it { subject.must_equal false }
    end
  end

end