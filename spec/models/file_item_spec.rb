require_relative '../../app/models/file_item'
require 'date'

describe FileItem, type: :model do
  subject { FileItem.new(name, content, created_by) }

  let(:name) { 'file_1' }
  let(:content) { 'some content' }
  let(:created_by) { 'some user' }

  it { expect(subject.name).to eq name }
  it { expect(subject.content).to eq content }
  it { expect(subject.created_by).to eq created_by }

  context '#display' do
    let(:message) { "#{subject.class}: #{name} (Created by: #{created_by})" }
    it { expect(subject.display).to eq message }
  end
end
