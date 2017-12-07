class MemoryReallocator
  def initialize(blocks)
    @cycles = {}
    @lookup = blocks.join(" ")
    reallocate(blocks)
  end

  def reallocate(current_blocks)
    until @cycles[@lookup]
      @cycles[@lookup] = @cycles.keys.length
      max_index = current_blocks.find_index(current_blocks.max)
      addition_blocks = current_blocks.rotate(max_index)
      max_block = addition_blocks.shift
      diff = max_block > addition_blocks.length ? max_block % addition_blocks.length : 0
      distributive_amount = max_block - diff
      current_blocks = addition_blocks.map do |block|
        if distributive_amount == 0
          block_amount = 0
        elsif distributive_amount > addition_blocks.length
          block_amount = distributive_amount / addition_blocks.length
        else
          block_amount = 1
        end
        distributive_amount -= block_amount
        block + block_amount
      end.unshift(diff).rotate(-max_index)
      @lookup = current_blocks.join(" ")
    end
  end

  def total_cycles
    @cycles.keys.count
  end

  def cycles_since_first_seen
    @cycles.keys.count - @cycles[@lookup]
  end
end

require "minitest/autorun"
require "minitest/pride"

class MemoryReallocatorTest < Minitest::Test
  def test_it_counts_cycles
    assert_equal 5, MemoryReallocator.new([0, 2, 7, 0]).total_cycles
  end

  def test_it_counts_cycles_since_first_seen
    assert_equal 4, MemoryReallocator.new([0, 2, 7, 0]).cycles_since_first_seen
  end
end

memory = [2, 8, 8, 5, 4, 2, 3, 1, 5, 5, 1, 2, 15, 13, 5, 14]
memory_reallocator = MemoryReallocator.new(memory)
puts memory_reallocator.total_cycles
puts memory_reallocator.cycles_since_first_seen
