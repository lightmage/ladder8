require 'spec_helper'

describe "players/show" do
  before(:each) do
    @player = assign(:player, stub_model(Player,
      :nick => "Nick",
      :password_digest => "Password Digest",
      :avatar => "Avatar",
      :timezone => "Timezone"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Nick/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password Digest/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Avatar/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Timezone/)
  end
end
