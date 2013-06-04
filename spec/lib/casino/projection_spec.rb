describe Casino::Projection do

  let(:projection) { Casino::Projection.new(Model) }

  describe '#results' do
    it "sends the pipeline to the collection's aggregate method" do
      Model.collection.stub(:aggregate, []) do
        projection.results.must_equal []
      end
    end
  end

  describe '#mongoize' do
    let(:hash) do
      { group: { '_id' => :email, 'count' => { sum: 1 } } }
    end
    let(:mongoized_hash) do
      { '$group' => { '_id' => '$email', 'count' => { '$sum' => 1 } } }
    end
    subject { projection.mongoize(hash) }
    it { subject.must_equal mongoized_hash }
  end

  describe '#group' do
    let(:group_hash) do
      { '$group'  => { '_id' => '$author' } }
    end
    subject { projection.group('_id' => :author) }
    it { subject.pipeline.must_include group_hash }
  end

  describe '#project' do
    let(:project_hash) do
      { '$project'  => { 'person' => '$human' } }
    end
    subject { projection.project('person' => :human) }
    it { subject.pipeline.must_include project_hash }
  end

  describe '#unwind' do
    let(:unwind_hash) do
      { '$unwind' => '$notes' }
    end
    subject { projection.unwind(:notes) }
    it { subject.pipeline.must_include unwind_hash }
  end

  describe '#match' do
    let(:today) { Date.today }
    let(:match_hash) do
      { '$match'  => { '$created_at' => { '$gte' => today } } }
    end
    subject { projection.match(created_at: { gte: today }) }
    it { subject.pipeline.must_include match_hash }
  end

  describe '#sort' do
    let(:sort_hash) do
      { '$sort'  => { 'count' => -1 } }
    end
    subject { projection.sort('count' => -1) }
    it { subject.pipeline.must_include sort_hash }
  end

  describe '#skip' do
    let(:skip_hash) do
      { '$skip'  => 10 }
    end
    subject { projection.skip(10) }
    it { subject.pipeline.must_include skip_hash }
  end

  describe '#limit' do
    let(:limit_hash) do
      { '$limit'  => 10 }
    end
    subject { projection.limit(10) }
    it { subject.pipeline.must_include limit_hash }
  end

end