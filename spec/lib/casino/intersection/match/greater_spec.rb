describe Casino::Intersection::Match::Greater do

  let(:system) { Casino::Intersection::Match::Greater }

  describe 'greater than' do

    describe '#eligible?' do
      describe "when the key is $gt" do
        let(:matcher) { system.new '$gt', '', '', '' }
        subject { matcher.eligible? }
      end
    end

    describe '#evaluate' do

      describe 'when the value is greater than the field' do
        it "returns true" do
          matcher = system.new '$gt', Date.today, '', Date.yesterday
          matcher.evaluate.must_equal true
        end
      end

      describe 'when the value is less than the field' do
        it "returns false" do
          matcher = system.new '$gt', Date.yesterday, '', Date.today
          matcher.evaluate.must_equal false
        end
      end

    end

  end

  describe 'greater than or equal to' do

    describe '#eligible?' do
      describe "when the key is $gt" do
        it "returns true" do
          matcher = system.new '$gte', '', '', ''
          matcher.eligible?.must_equal true
        end
      end
    end

    describe '#evaluate' do

      describe 'when the value is greater than the field' do
        it "returns true" do
          matcher = system.new '$gte', Date.today, '', Date.yesterday
          matcher.evaluate.must_equal true
        end
      end

      describe 'when the value is equal to the field' do
        it "returns true" do
          matcher = system.new '$gte', Date.yesterday, '', Date.yesterday
          matcher.evaluate.must_equal true
        end
      end

      describe 'when the value is less than the field' do
        it "returns false" do
          matcher = system.new '$gte', Date.yesterday, '', Date.today
          matcher.evaluate.must_equal false
        end
      end

    end

  end

end