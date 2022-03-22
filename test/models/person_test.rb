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
    assert @person.valid?, "P should be valid with no emoji but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows no emoji (set explicitly)" do
    @person.emoji = nil

    assert @person.valid?, "P should be valid with no emoji but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows blank emoji" do
    @person.emoji = ""

    assert @person.valid?, "P should be valid with blank string but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows ASCII whitespace string" do
    @person.emoji = " \t\n"

    assert @person.valid?, "P should be valid with whitespace string but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows simple emoji" do
    @person.emoji = "👍"

    assert @person.valid?, "P should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows skintone emoji" do
    @person.emoji = ""

    assert @person.valid?, "P should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows flag emoji" do
    @person.emoji = "🇰🇭"

    assert @person.valid?, "P should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows emoji with ASCII whitespace around them" do
    @person.emoji = " 👍 "

    assert @person.valid?, "P should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Allows other complex emoji" do
    @person.emoji = "👨‍👩‍👧‍👦" # 7 code points in total

    assert @person.valid?, "P should be valid with #{@person.emoji} but isn't\n\n\t#{@person.errors.full_messages}"
  end

  test "Does not allow emoji modifiers on their own" do
    @person.emoji = "‍" # Zero width joiner (+U200D) between quotes

    assert_not @person.valid?, "P should not be valid with zero width joiner but is"
  end

  test "Does not allow non-recommend (RGI) emoji" do
    @person.emoji = "🏴󠁧󠁢󠁮󠁩󠁲󠁿"

    assert_not @person.valid?, "P should be not be valid with Northern Ireland flag but is"
  end

  test "Does not allow multiple emoji" do
    @person.emoji = "👨👩👧👦" # Same 4 as above but without zero width joiners

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow ASCII emoticons" do
    @person.emoji = ":)"

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow a single ASCII character" do
    @person.emoji = "@"

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow a non-emoji representation of emoji symbol" do
    @person.emoji = "®"

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow textual emoji" do
    @person.emoji = "↕"

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow non-Emoji unicode strings" do
    @person.emoji = "សួស្តី​ពិភពលោក"

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "Does not allow a single non-Emoji unicode character" do
    @person.emoji = "ស"

    assert_not @person.valid?, "P should not be valid with #{@person.emoji} but is"
  end

  test "skin tone thumbs up" do
    emoji = "👍🏽"
    print "#{emoji} codepoints:\t"
    emoji.each_codepoint{|c| p c.to_s(16).upcase, " "}

    assert emoji.grapheme_clusters.length == 1
    assert emoji.scan(Unicode::Emoji::REGEX_VALID) == emoji, "Valid regex match of recommended emoji should match orginal"
    assert emoji.scan(Unicode::Emoji::REGEX) == emoji, "RGI regex match of recommended emoji should match orginal"
    assert emoji.scan(Unicode::Emoji::REGEX).length == emoji.length, "Length of RGI regex match of recommended emoji should match length of orginal"
  end

  test "Cambodian flag" do
    emoji = "🇰🇭"
    puts "#{emoji}:\t#{emoji.codepoints.join(" ")}"

    assert emoji.grapheme_clusters.length == 1
    assert emoji.scan(Unicode::Emoji::REGEX_VALID) == emoji, "Valid regex match of recommended emoji should match orginal"
    assert emoji.scan(Unicode::Emoji::REGEX) == emoji, "RGI regex match of recommended emoji should match orginal"
    assert emoji.scan(Unicode::Emoji::REGEX).length == emoji.length, "Length of RGI regex match of recommended emoji should match length of orginal"
  end

  test "my family" do
    emoji = "👨‍👩‍👧‍👦"
    puts "#{emoji}:\t#{emoji.each_codepoint {|c| print c, ' '}}"

    assert emoji.grapheme_clusters.length == 1
    assert emoji.scan(Unicode::Emoji::REGEX_VALID) == emoji, "Valid regex match of recommended emoji should match orginal"
    assert emoji.scan(Unicode::Emoji::REGEX) == emoji, "RGI regex match of recommended emoji should match orginal"
    assert emoji.scan(Unicode::Emoji::REGEX).length == emoji.length, "Length of RGI regex match of recommended emoji should match length of orginal"
  end
end
