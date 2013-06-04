describe Casino::Intersection::Match::Lesser do

  let(:system) { Casino::Intersection::Match::Lesser }

  describe 'lesser than' do

    describe '#eligible?' do
      describe "when the key is $lt" do
        it "returns true" do
          matcher = system.new '$lt', '', '', ''
          matcher.eligible?.must_equal true
        end
      end
    end

    describe '#evaluate' do

      describe 'when the value is less than the field' do
        it "returns true" do
          matcher = system.new '$lt', Date.yesterday, '', Date.today
          matcher.evaluate.must_equal true
        end
      end

      describe 'when the value is greater than the field' do
        it "returns false" do
          matcher = system.new '$lt', Date.today, '', Date.yesterday
          matcher.evaluate.must_equal false
        end
      end

    end

  end

  describe 'lesser than or equal to' do

    describe '#eligible?' do
      describe "when the key is $lte" do
        it "returns true" do
          matcher = system.new '$lte', '', '', ''
          matcher.eligible?.must_equal true
        end
      end
    end

    describe '#evaluate' do

      describe 'when the value is less than the field' do
        it "returns true" do
          matcher = system.new '$lte', Date.yesterday, '', Date.today
          matcher.evaluate.must_equal true
        end
      end

      describe 'when the value is equal to the field' do
        it "returns true" do
          matcher = system.new '$lte', Date.today, '', Date.today
          matcher.evaluate.must_equal true
        end
      end

      describe 'when the value is greater than the field' do
        it "returns false" do
          matcher = system.new '$lte', Date.today, '', Date.yesterday
          matcher.evaluate.must_equal false
        end
      end

    end

  end

end