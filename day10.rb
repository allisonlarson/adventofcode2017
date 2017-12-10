class KnotHash
  attr_reader :list
  def initialize(number_of_elements, lengths, suffix=nil)
    @skip = 0
    @lengths = lengths
    @suffix = suffix
    @index = 0
    @list = Array (0...number_of_elements)
  end

  def simple_hash
    process_round
    @list[0] * @list[1]
  end

  def hash
    @lengths = @lengths.join(",").chars.map {|c| c.ord} + @suffix
    64.times { process_round }
    @list.each_slice(16).map { |chunk| chunk.inject(0) { |acc, num| acc ^ num } }.map { |d| "%02x" % d }.join("")
  end

  private

  def process_round
    @lengths.each do |length|
      rotated_list = @list.rotate(@index)
      current = rotated_list.slice!(0...length)
      new_list = current.reverse + rotated_list
      @list = new_list.rotate(-@index)
      @index += length + @skip
      @index -= @list.length if @index > @list.length
      @skip += 1
    end
  end
end

require "minitest/autorun"
require "minitest/pride"

class KnotHashTest < Minitest::Test
  def test_it_hashes
    lengths = [3, 4, 1, 5]
    knot_hash = KnotHash.new(5, lengths)
    value = knot_hash.simple_hash
    assert_equal [3, 4, 2, 1, 0], knot_hash.list
    assert_equal 12, value
  end
end

simple_lengths = [76,1,88,148,166,217,130,0,128,254,16,2,130,71,255,229]
suffix = [17, 31, 73, 47, 23]
puts KnotHash.new(256, simple_lengths).simple_hash
puts KnotHash.new(256, simple_lengths, suffix).hash
