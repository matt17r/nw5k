require "test_helper"

class PersonTest < ActiveSupport::TestCase
  setup do
    @person = Person.new(
      name: "Fred Flintstone",
      email: "fred@flintstone",
      password: "Super Secret Password"
    )
  end

  test "Allows no emoji (set implicitly)" do
    assert @person.valid?, "should be valid with no emoji but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows no emoji (set explicitly)" do
    @person.emoji = nil

    assert @person.valid?, "should be valid with no emoji but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows blank emoji" do
    @person.emoji = ""

    assert @person.valid?, "should be valid with blank string but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows ASCII whitespace string" do
    @person.emoji = " \t\n"

    assert @person.valid?, "should be valid with whitespace string but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows simple emoji" do
    @person.emoji = "👍"

    assert @person.valid?, "should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows emoji with skintone" do
    @person.emoji = "👍🏽"

    assert @person.valid?, "should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows recommended flag emoji" do
    @person.emoji = "🇰🇭"

    assert @person.valid?, "should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Does not allow non-recommend (non-RGI) flag emoji" do
    @person.emoji = "🏴󠁧󠁢󠁮󠁩󠁲󠁿"

    assert_not @person.valid?, "should be not be valid with Northern Ireland flag but is - #{@person.emoji.scan(Unicode::Emoji::REGEX)[0]}"
  end

  test "Allows emoji with ASCII whitespace around them" do
    @person.emoji = " 👍 "

    assert @person.valid?, "should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows other complex emoji" do
    # skip "Reported an issue to the gem maintainter about this"
    @person.emoji = "👨‍👩‍👧‍👦" # 7 code points in total

    assert @person.valid?, "should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Does not allow multiple emoji" do
    @person.emoji = "👨👩👧👦" # Same 4 as above but without zero width joiners

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow emoji modifiers on their own" do
    @person.emoji = "‍" # Zero width joiner (+U200D) between quotes

    assert_not @person.valid?, "should not be valid with zero width joiner but is"
  end

  test "Does not allow ASCII emoticons" do
    @person.emoji = ":)"

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow a single ASCII character" do
    @person.emoji = "@"

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow a non-emoji representation of emoji symbol" do
    @person.emoji = "®"

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow textual emoji" do
    @person.emoji = "↕"

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow non-Emoji unicode strings" do
    @person.emoji = "សួស្តី​ពិភពលោក"

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow a single non-Emoji unicode character" do
    @person.emoji = "ស"

    assert_not @person.valid?, "should not be valid with #{@person.emoji} but is"
  end
end
