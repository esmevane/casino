describe Casino::Intersection::Match::All do

  let(:system) { Casino::Intersection::Match::All }

  describe '#eligible?' do
    let(:matcher) { system.new('$and', '', '', '') }
    subject { matcher.eligible? }
    it { subject.must_equal true }
  end

  describe '#evaluate' do

    let(:matcher) { system.new('$and', '', '', [{}]) }
    let(:base) { Casino::Intersection::Match::Base }
    subject { matcher.evaluate }
    it 'builds base matchers to evaluate' do
      base.stub(:new, OpenStruct.new(evaluate: true)) do
        subject.must_equal true
      end
    end

  end

end
