require 'spec_helper'

describe "players/index" do
  before(:each) do
    assign(:players, [
      stub_model(Player,
        :nick => "Nick",
        :password_digest => "Password Digest",
        :avatar => "Avatar",
        :timezone => "Timezone"
      ),
      stub_model(Player,
        :nick => "Nick",
        :password_digest => "Password Digest",
        :avatar => "Avatar",
        :timezone => "Timezone"
      )
    ])
  end

  it "renders a list of players" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nick".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Password Digest".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Timezone".to_s, :count => 2
  end
end
