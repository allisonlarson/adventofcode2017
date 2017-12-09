class HighEntropyPassphrase
  def valid(passphrase)
    split_passphrases = passphrase.split(" ")
    split_passphrases.length == split_passphrases.map { |word| word.split("").sort.join("") }.uniq.length
  end
end

require 'minitest/autorun'
require 'minitest/pride'

class HighEntropyPassphraseTest < Minitest::Test
  def test_it_contains_no_duplicates
    high_entropy_passphrase = HighEntropyPassphrase.new
    assert high_entropy_passphrase.valid("aa bb cc dd ee")
    refute high_entropy_passphrase.valid("aa bb cc dd aa")
    assert high_entropy_passphrase.valid("aa bb cc dd aaa")
  end

  def test_it_contains_no_duplicate_anagrams
    high_entropy_passphrase = HighEntropyPassphrase.new
    assert high_entropy_passphrase.valid("abcde fghij")
    refute high_entropy_passphrase.valid("abcde xyz ecdab")
    assert high_entropy_passphrase.valid("a ab abc abd abf abj")
    refute high_entropy_passphrase.valid("oiii ioii iioi iiio")
    assert high_entropy_passphrase.valid("iiii oiii ooii oooi oooo")
  end
end

passphrases = File.read("./inputs/day4.txt")
puts passphrases.split("\n").select { |passphrase| HighEntropyPassphrase.new.valid(passphrase) }.length

