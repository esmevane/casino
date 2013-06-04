require 'spec_helper'

describe Casino::Question do
  let(:name) { :emails }
  let(:answer) { :distinct_emails }
  let(:question) { Casino::Question.new(name, answer) }
  subject { question }
  it { subject.name.must_equal name }
  it { subject.answer.must_equal answer }
end
