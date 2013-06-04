describe Casino::Intersection do

  let(:label) { [ Date.today.strftime("%m/%d/%Y"), "Facebook" ] }
  let(:criteria) { Model.scoped }
  let(:intersection) { Casino::Intersection.new(label, criteria) }

  subject { intersection }

  it { subject.label.must_equal label }
  it { subject.criteria.must_equal criteria }
  it { subject.must_respond_to :selector }

  describe '#match?' do

    let(:model) { Model.new }
    let(:criteria) { Model.where(created_at: Date.today) }
    let(:intersection) { Casino::Intersection.new(label, criteria) }
    let(:value) { model.created_at }
    let(:base_class) { Casino::Intersection::Match::Base }
    let(:base_mock) { MiniTest::Mock.new }
    let(:base_instance) { base_class.new(*base_arguments) }
    let(:base_arguments) { [model, 'created_at', intersection.selector, value] }

    it "invokes a Casino::Intersection::Match::Base instance" do
      base_mock.expect(:evaluate, base_instance)
      base_class.stub(:new, base_mock) do
        intersection.match?(model)
      end
      base_mock.verify
    end
  end

end