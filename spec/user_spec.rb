require "spec_helper"

require "user"

describe User do

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

