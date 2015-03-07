require 'rails_helper'

RSpec.describe Item, type: :model do

  it "can be created" do
    user = build(:user)
    user.save

    expect(user.valid?).to eq true

    item = Item.create(name: "Finish BLOC", user_id: user.id)

    expect(item.name).to eq("Finish BLOC")
    expect(item.user_id).to eq(user.id)
  end

  it "can be read " do
    user = build(:user)
    user.save

    item = Item.create(name: "Finish BLOC", user_id: user.id)

    item1 = Item.find_by(name: "Finish BLOC")

    expect(item1.changed?).to be(false)
    expect(item1.name).to eq("Finish BLOC")
    expect(item1.user_id).to eq(user.id)
  end

  it "can be updated" do
    user = build(:user)
    user.save

    item = Item.create(name: "Finish BLOC", user_id: user.id)

    item1 = Item.find_by(name: "Finish BLOC")

    item1.name = "By May"
    expect(item1.changed?).to be(true)
    expect(item1.name).to eq("By May")
    expect(item1.user_id).to eq(user.id)
  end

  it "delete it" do
    user = build(:user)
    user.save

    item = Item.create(name: "Finish BLOC", user_id: user.id)

    item1 = Item.find_by(name: "Finish BLOC")
    item1.destroy

    expect(item1.destroyed?).to be(true)

  end

end
