require 'spec_helper'

describe Casino::Lobby do

  let(:collection) { Collection }
  let(:object_class) { Model }
  let(:object_instance) { object_class.new }
  let(:object_key) { object_class.name.downcase.split("::").last.to_sym }
  let(:lobby) { Casino::Lobby.new(collection) }

  subject { lobby }

  it { subject.collection.must_equal collection }

  it "stores objects instances in a registry" do
    subject.add_registry(object_instance)
    subject.registry[object_key].must_include object_instance
  end

end
