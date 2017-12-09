require 'prime'
class Checksum
  def initialize(spreadsheet)
    @rows = spreadsheet.map { |row| Row.new(row) }
  end

  def eval(strategy = :default)
    @rows.inject(0) { |sum, row| sum + row.value(strategy) }
  end

  class Row
    def initialize(row_data)
      @data = row_data.sort
    end

    def value(type)
      return @data.last - @data.first if type == :default
      @data.map do |current_number|
        next unless !current_number.prime?
        divisible = @data.detect { |number| (current_number != number) && (current_number % number == 0) }
        return current_number / divisible if divisible
      end
    end
  end
end

require 'minitest/autorun'
require 'minitest/pride'

class ChecksumTest < Minitest::Test
  def test_it_exists
    assert Checksum.new([])
  end

  def test_it_finds_a_checksum
    spreadsheet = [
      [5, 1, 9, 5],
      [7, 5, 3],
      [2, 4, 6, 8]
    ]

    assert_equal 18, Checksum.new(spreadsheet).eval
  end

  def test_it_finds_a_checksum_by_divisibility
    spreadsheet = [
      [5, 9, 2, 8,],
      [9, 4, 7, 3,],
      [3, 8, 6, 5,],
    ]

    assert_equal 9, Checksum.new(spreadsheet).eval(:divisible)
  end
end

spreadsheet = File.read("./inputs/day2.txt").split("\n").map { |r| r.split("  ").map(&:to_i) }

checksum = Checksum.new(spreadsheet)
puts checksum.eval
puts checksum.eval(:divisible)
