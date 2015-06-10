require "spec_helper"

require "user"

describe User do

  describe "validates" do
    let(:user) { User.new(data) }

    subject { user }

    context "presence" do
      let(:data) { {age: 600} }
      it { should_not be_valid }
    end
  end

  describe ".new" do
    let(:user) { User.new(data) }

    context "from hash" do
      let(:data) { {name: "Deirdre Skye", age: 600} }

      specify { expect(user.name).to eq "Deirdre Skye" }
      specify { expect(user.age).to eq 600 }
      specify { expect(user.attributes[:name]).to eq "Deirdre Skye" }
      specify { expect(user.attributes[:age]).to eq 600 }
    end

    context "from json" do
      let(:data) { JSON.dump({name: "Deirdre Skye", age: 600}) }

      specify { expect(user.name).to eq "Deirdre Skye" }
      specify { expect(user.age).to eq 600 }
      specify { expect(user.attributes[:name]).to eq "Deirdre Skye" }
      specify { expect(user.attributes[:age]).to eq 600 }
    end
  end
end

