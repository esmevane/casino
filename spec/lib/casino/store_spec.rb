describe Casino::Store do

  let(:key) { "collection_name" }
  let(:store) { Casino::Store.new(key) }

  subject { store }

  it { subject.must_respond_to :collection_name }

  it "establishes a connection to the default session" do
    store.collection.database.session.must_equal Mongoid.default_session
  end

  it "establishes a connection to the correct collection" do
    store.collection.name.must_equal key
  end

  describe '#criteria' do
    it "provides a criteria interface" do
      store.criteria.must_be_instance_of Mongoid::Criteria
    end
  end

  describe '#merge' do

    let(:womens_boots) do
      { '_id' => { 'date' => Date.today, 'label' => "women's boots" } }
    end

    let(:mens_boots) do
      { '_id' => { 'date' => Date.today, 'label' => "men's boots" } }
    end

    let(:value_hash) do
      { 'value' => { 'signups' => 10850, 'uniques' => 9822 } }
    end

    let(:document) { womens_boots.merge(value_hash) }
    let(:document_two) { mens_boots.merge(value_hash) }

    it "adds new documents to the collection" do
      store.merge(document)
      store.first.must_equal store.mongoize(document)
    end

    it "updates documents" do
      store.merge(document)
      store.merge(document.merge(value: { signups: 2 }))
      store.first['value']['signups'].must_equal 2
    end

    it "does not replace the wrong document" do
      store.merge(document)
      store.merge(document_two)
      store.find.count.wont_equal 1
    end

  end

end
