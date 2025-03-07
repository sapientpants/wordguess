defmodule WordGuess.WordDictionaryTest do
  use ExUnit.Case, async: true
  alias WordGuess.WordDictionary

  describe "all_words/0" do
    test "returns a list of words" do
      words = WordDictionary.all_words()
      assert is_list(words)
      assert length(words) > 0
      assert Enum.all?(words, &is_binary/1)
    end
  end

  describe "words_by_difficulty/1" do
    test "returns easy words when :easy is provided" do
      words = WordDictionary.words_by_difficulty(:easy)
      assert is_list(words)
      assert length(words) > 0
      assert Enum.all?(words, &is_binary/1)

      # Check that all words are categorized as easy
      assert Enum.all?(words, fn word ->
               WordDictionary.determine_difficulty(word) == :easy
             end)
    end

    test "returns medium words when :medium is provided" do
      words = WordDictionary.words_by_difficulty(:medium)
      assert is_list(words)
      assert length(words) > 0
      assert Enum.all?(words, &is_binary/1)

      # Check that all words are categorized as medium
      assert Enum.all?(words, fn word ->
               WordDictionary.determine_difficulty(word) == :medium
             end)
    end

    test "returns hard words when :hard is provided" do
      words = WordDictionary.words_by_difficulty(:hard)
      assert is_list(words)
      assert length(words) > 0
      assert Enum.all?(words, &is_binary/1)

      # Check that all words are categorized as hard
      assert Enum.all?(words, fn word ->
               WordDictionary.determine_difficulty(word) == :hard
             end)
    end

    test "returns all words when an invalid difficulty is provided" do
      all_words = WordDictionary.all_words()
      invalid_words = WordDictionary.words_by_difficulty(:invalid)

      assert all_words == invalid_words
    end
  end

  describe "random_word/0" do
    test "returns a random word from all words" do
      word = WordDictionary.random_word()
      assert is_binary(word)
      assert word in WordDictionary.all_words()
    end
  end

  describe "random_word/1" do
    test "returns a random word of the specified difficulty" do
      easy_word = WordDictionary.random_word(:easy)
      assert is_binary(easy_word)
      assert easy_word in WordDictionary.words_by_difficulty(:easy)

      medium_word = WordDictionary.random_word(:medium)
      assert is_binary(medium_word)
      assert medium_word in WordDictionary.words_by_difficulty(:medium)

      hard_word = WordDictionary.random_word(:hard)
      assert is_binary(hard_word)
      assert hard_word in WordDictionary.words_by_difficulty(:hard)
    end
  end

  describe "determine_difficulty/1" do
    test "returns :easy for predefined easy words" do
      assert WordDictionary.determine_difficulty("cat") == :easy
      assert WordDictionary.determine_difficulty("dog") == :easy
      assert WordDictionary.determine_difficulty("run") == :easy
      assert WordDictionary.determine_difficulty("jump") == :easy
    end

    test "returns :medium for predefined medium words" do
      # Test with known medium words from the implementation
      assert WordDictionary.determine_difficulty("apple") == :medium
      assert WordDictionary.determine_difficulty("beach") == :medium
      assert WordDictionary.determine_difficulty("cloud") == :medium
      assert WordDictionary.determine_difficulty("dance") == :medium
    end

    test "returns :hard for predefined hard words" do
      assert WordDictionary.determine_difficulty("amazing") == :hard
      assert WordDictionary.determine_difficulty("balance") == :hard
      assert WordDictionary.determine_difficulty("captain") == :hard
      assert WordDictionary.determine_difficulty("diamond") == :hard
    end

    test "uses length-based categorization for words not in predefined lists" do
      # Based on the implementation, words are categorized by length:
      # - Easy: <= 4 characters
      # - Medium: <= 6 characters
      # - Hard: > 6 characters
      # 2 chars
      assert WordDictionary.determine_difficulty("hi") == :easy
      # 4 chars
      assert WordDictionary.determine_difficulty("test") == :easy
      # 5 chars
      assert WordDictionary.determine_difficulty("hello") == :medium
      # 6 chars
      assert WordDictionary.determine_difficulty("puzzle") == :medium
      # 7 chars
      assert WordDictionary.determine_difficulty("testing") == :hard
      # 11 chars
      assert WordDictionary.determine_difficulty("programming") == :hard
    end
  end
end
