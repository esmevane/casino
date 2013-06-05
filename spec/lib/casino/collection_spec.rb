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

    describe '#query' do
      subject { Collection.new.query('', '', '') }
      it { subject.must_be_instance_of Casino::Query }
    end

    describe '#store' do
      subject { emails_by_day.store }
      it { subject.must_be_instance_of Casino::Store }
    end

    describe '#results' do
      subject { emails_by_day.results }
      it { subject.must_be_instance_of Mongoid::Criteria }
    end

    describe '#update' do
      subject { emails_by_day.update }
      it { subject.must_be_instance_of Mongoid::Criteria }
    end

    describe '#insert' do
      subject { emails_by_day.insert(Model.new) }
      it "returns a `Mongoid::Criteria`" do
        subject.must_be_instance_of Mongoid::Criteria
      end
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
