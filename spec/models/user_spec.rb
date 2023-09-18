require_relative '../../app/models/user'

describe User, type: :model do
  subject { User.new(username, password) }

  let(:username) { 'iosu' }
  let(:password) { 'password00' }

  it { expect(subject.username).to eq username }
  it { expect(subject.password).to eq password }
end
