require 'spec_helper'

describe "players/edit" do
  before(:each) do
    @player = assign(:player, stub_model(Player,
      :nick => "MyString",
      :password_digest => "MyString",
      :avatar => "MyString",
      :timezone => "MyString"
    ))
  end

  it "renders the edit player form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => players_path(@player), :method => "post" do
      assert_select "input#player_nick", :name => "player[nick]"
      assert_select "input#player_password_digest", :name => "player[password_digest]"
      assert_select "input#player_avatar", :name => "player[avatar]"
      assert_select "input#player_timezone", :name => "player[timezone]"
    end
  end
end
