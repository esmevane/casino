require 'spec_helper'

describe Casino::Document do
  describe '#compose' do
    subject { Casino::Document.new('key', ['Question Name']).compose }
    it { subject.new.must_respond_to :question_name }
    it { subject.new.must_respond_to :question_name= }
    it { subject.ancestors.must_include Mongoid::Document }
    it { subject.collection_name.must_equal :key }
  end
end
