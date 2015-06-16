require "spec_helper"

require "user"

describe User do

  describe "validates" do
    let(:user) { User.new(data) }

    subject { user }

    context "presence" do
      let(:data) { {name: "Foo"} }
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


  describe "requests" do

    before(:each) { clean_db }


    describe ".all" do

      before(:each) do
        create_list(:user, 3)
      end

      specify { expect(described_class.all.count).to eq 3 }
      specify { expect(described_class.all.first.name).to eq "Deirdre Skye" }
    end

    describe ".where" do

      let!(:walter) { create(:user, name: "Walter") }
      let!(:walter_jr) { create(:user, name: "Walter") }
      let!(:skyler) { create(:user, name: "Skyler") }

      context "=" do
        let(:query) { {name: "Walter"} }

        specify "returns correct entries" do
          ids = described_class.where(query).map(&:id)
          expect(ids).to include walter.id, walter_jr.id
          expect(ids).to_not include skyler.id
        end
      end
    end

    describe ".find" do
      let(:user) { create(:user) }

      specify { expect(described_class.find(user.id).name).to eq user.name }
      specify { expect(described_class.find(:foo)).to be_nil }
    end


    describe "#save" do

      context "old record" do
        let(:user) { create(:user) }

        before(:each) do
          user.name = name
          user.save
        end

        context "when valid" do
          let(:name) { "Foo" }

          specify { expect(user.name).to eq "Foo" }
          specify { expect(described_class.find(user.id).name).to eq "Foo" }
        end

        context "when invalid" do
          let(:name) { nil }

          specify { expect(user.errors[:name]).to be }
          specify { expect(described_class.find(user.id).name).to eq "Deirdre Skye" }
        end
      end

      context "new record" do
        let(:user) { build(:user, data) }

        context "when valid" do
          let(:data) { {name: "Foo", age: 20} }

          before(:each) do
            user.save
          end

          specify { expect(user).to be_persisted }
          specify { expect(user.id).to be }
          specify { expect(described_class.find(user.id).name).to eq "Foo" }
        end

        context "when invalid" do
          let(:data) { {name: nil} }

          before(:each) do
            user.save
          end

          specify { expect(user).to_not be_persisted }
          specify { expect(user.id).to be_nil }
          specify { expect(user.errors[:name]).to be }
        end
      end
    end

    describe "#destroy" do
      let!(:user) { create(:user) }

      specify "makes object not persisted" do
        user.destroy
        expect(user).to_not be_persisted
      end

      specify "deletes record from database" do
        user.destroy
        expect(User.find(user.id)).not_to be
      end
    end
  end
end

