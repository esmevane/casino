describe Casino::Store do

  let(:key) { "collection_name" }
  let(:document) { Casino::Document.new(key, ['value']).compose }
  let(:store) { Casino::Store.new(document) }

  subject { store }

  it { subject.must_respond_to :collection_name }
  it { subject.must_respond_to :collection_class }

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

    let(:attributes) { womens_boots.merge(value_hash) }
    let(:attributes_two) { mens_boots.merge(value_hash) }

    it "adds new document attributes to the collection" do
      store.merge(attributes)
      store.first.must_equal attributes.mongoize
    end

    it "updates documents with new attributes" do
      store.merge(attributes)
      store.merge(attributes.merge(value: { signups: 2 }))
      store.first['value']['signups'].must_equal 2
    end

    it "does not replace the wrong document" do
      store.merge(attributes)
      store.merge(attributes_two)
      store.find.count.wont_equal 1
    end

  end

end
