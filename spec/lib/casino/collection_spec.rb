require 'spec_helper'

describe Casino::Collection do
  describe "making a Casino collection" do
    it { Collection.must_respond_to :dimension }
    it { Collection.must_respond_to :focus }
    it { Collection.must_respond_to :question }
    it { Collection.must_respond_to :lobby }
    it { Collection.must_respond_to :register }
    it { Collection.new.must_respond_to :query }
    it { Collection.new.must_respond_to :intersection }
    it { Collection.new.must_respond_to :answer }
    it { Collection.new.must_respond_to :projection }
  end

  describe '.dimension' do
    let(:field) { :created_at }
    let(:queries) { [] }
    let(:approach) { { operator: :and } }
    subject { Collection.dimension(field, queries, approach) }
    it { subject.must_be_instance_of Casino::Dimension }
    it "registers the dimension with the Lobby" do
      dimension = Collection.dimension(field, queries, approach)
      Collection.lobby.registry[:dimension].must_include dimension
    end
  end

  describe '.focus' do
    let(:model) { Model }
    let(:focus) { Collection.focus(model) }
    subject { focus }
    it { subject.must_be_instance_of Casino::Focus }
    it "registers the focus with the Lobby" do
      focus = Collection.focus(Model)
      Collection.lobby.registry[:focus].first.must_equal focus
    end
  end

  describe '.question' do
    let(:name) { :emails }
    let(:answer) { -> { distinct(:email) } }
    subject { Collection.question(name, answer) }
    it { subject.must_be_instance_of Casino::Question }
    it "registers the question with the Lobby" do
      question = Collection.question(name, answer)
      Collection.lobby.registry[:question].must_include question
    end
  end

  describe 'instance methods' do

    let(:emails_by_day) { EmailsByDay.new }

    describe '#query' do

      let(:collection) { Collection.new }
      let(:label) { "Date of creation" }
      let(:criteria_one) { "criteria one" }
      let(:criteria_two) { "criteria two" }
      let(:arguments) { [ criteria_one, criteria_two ] }

      subject { collection.query(label, *arguments) }

      it { subject.must_be_instance_of Casino::Query }

    end

    describe 'registry accessors' do

      let(:registry) { emails_by_day.class.lobby.registry }
      let(:dimensions) { registry[:dimension] }
      let(:questions) { registry[:question] }
      let(:focus) { registry[:focus] }

      subject { emails_by_day }

      it { subject.dimensions.must_equal dimensions }
      it { subject.focus.must_equal focus }
      it { subject.questions.must_equal questions }

    end

    describe '#queries' do

      let(:dimension) { emails_by_day.dimensions.first }
      let(:queries) { emails_by_day.queries(dimension) }

      let(:built_conditions) do
        emails_by_day.send(dimension.queries).map do |query|
          query.build_conditions(dimension)
        end
      end

      subject { queries.map(&:conditions) }

      it "merges dimension conditions into the target queries" do
        subject.must_equal built_conditions
      end

    end

    describe '#intersections' do

      let(:intersections) { emails_by_day.intersections }
      let(:dimensions) { emails_by_day.dimensions }
      let(:queries) { dimensions.map { |d| emails_by_day.queries(d) } }
      let(:combinations) { queries.map(&:length).reduce(&:*) }

      subject { intersections }

      it "produces all possible dimension and query combinations" do
        subject.length.must_equal combinations
      end

      it "produces Casino::Intersection instances" do
        subject.each do |object|
          object.must_be_instance_of Casino::Intersection
        end
      end

    end

    describe '#store' do
      subject { emails_by_day.store }
      it { subject.must_be_instance_of Casino::Store }
    end

    describe '#results' do
      subject { emails_by_day.results }
      it { subject.must_be_instance_of Mongoid::Criteria }
    end

    describe '#projection' do

      let(:selector) { Model.where(created_at: Time.now).selector }
      let(:mock) { OpenStruct.new(selector: selector) }

      subject { emails_by_day.projection }

      it { subject.must_be_instance_of Casino::Projection }

      it "is preloaded with the current criteria intersection" do
        emails_by_day.stub(:intersection, mock) do
          subject.pipeline.first['$match'].must_equal selector
        end
      end

    end

    describe '#intersection' do
      subject { emails_by_day.intersection }
      it { subject.must_be_instance_of Mongoid::Criteria }
      it "defaults to the base model criteria" do
        subject.must_equal Model.scoped
      end
    end

    describe '#answer' do
      subject { emails_by_day.answer(:count_emails) }
      it "calls the target method" do
        emails_by_day.stub(:count_emails, true) do
          subject.must_equal true
        end
      end
    end

    describe '#persist_results' do

      subject { emails_by_day.persist_results }

      it 'stores #collected_results with #merge' do
        mock = MiniTest::Mock.new
        mock.expect :merge, [], []
        emails_by_day.stub(:collected_results, []) do
          emails_by_day.stub(:store, mock) { subject }
        end
        mock.verify
      end

    end

    describe '#collected_results' do

      let(:stored) { [1] }
      let(:pending) { [2] }
      let(:both) { stored + pending }

      subject { emails_by_day.collected_results }

      it 'combines #stored_results and #pending_results' do
        emails_by_day.stub(:stored_results, stored) do
          emails_by_day.stub(:pending_results, pending) do
            subject.must_equal both
          end
        end
      end

    end

    describe '#pending_results' do

      let(:intersection) { Casino::Intersection.new "Label", Model.scoped }

      subject { emails_by_day.pending_results }

      it 'builds a list of hashes out of intersections + questions' do
        emails_by_day.stub(:pending_intersections, [intersection]) do
          subject.must_equal [{_id: {}}.merge(emails_by_day.answers)]
        end
      end

    end

    describe '#answers' do

      let(:question) { Casino::Question.new :pie, :count_emails }

      subject { emails_by_day.answers }

      it 'creates a hash out of question names and results' do
        emails_by_day.stub(:count_emails, true) do
          emails_by_day.stub(:questions, [question]) do
            subject.must_equal pie: true
          end
        end
      end

    end

    describe '#stored_results' do

      subject { emails_by_day.stored_results }

      it "queries for stored documents with intersection ids" do
        mock = MiniTest::Mock.new
        mock.expect :in, [], [{ id: [1] }]
        emails_by_day.stub(:intersection_ids, [1]) do
          emails_by_day.stub(:store, mock) { subject }
        end
        mock.verify
      end

    end

    describe '#intersection_ids' do

      let(:intersection) { Casino::Intersection.new "Label", Model.scoped }

      subject { emails_by_day.intersection_ids }

      it "gathers the selectors of all intersections" do
        emails_by_day.stub(:intersections, [intersection]) do
          subject.must_equal [ intersection.selector ]
        end
      end

    end

    describe '#pending_results' do

      let(:intersections) do
        %w(Google Facebook).map do |source|
          Casino::Intersection.new source, Model.where(source: source)
        end
      end

      subject { emails_by_day.pending_results }

      it "only returns un-persisted intersections" do
        emails_by_day.stub(:intersections, intersections) do
          emails_by_day.store.merge emails_by_day.pending_results.first
          subject.must_equal [ subject.last ]
        end
      end
    end

    describe '#key' do

      let(:string) do
        "emails_by_day_asks_model_about_unique_emails" +
          "_by_created_at_and_source"
      end

      let(:key) { Digest::SHA1.hexdigest(string) }

      subject { emails_by_day.key }
      it { subject.must_equal key }

    end

  end

end
