class RegisterExe
  attr_reader :largest_historical_value
  def initialize(commands)
    @registers = Hash.new { |h,k| h[k] = 0 }
    @largest_historical_value = 0
    commands.each { |c| execute_command(c) }
  end

  def value(register)
    @registers[register]
  end

  def largest_register
    @registers.values.max
  end

  private

  def execute_command(command)
    action, conditional = command.split(" if ")
    cond_var, comp, comp_val = conditional.split(" ")
    if @registers[cond_var].send(comp, comp_val.to_i)
      var, crem, value = action.split(" ")
      new_val = @registers[var].send((crem == "inc" ? "+" : "-"), value.to_i)
      @largest_historical_value = new_val if new_val > @largest_historical_value
      @registers[var] = new_val
    end
  end
end

require "minitest/autorun"
require "minitest/pride"

class RegisterExeTest < Minitest::Test
  def test_it_takes_commands
    commands = <<-COM
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
    COM
    register = RegisterExe.new(commands.split("\n"))
    assert_equal 1, register.value("a")
    assert_equal -10, register.value("c")
    assert_equal 0, register.value("b")
  end

  def test_it_returns_largest_value
    commands = <<-COM
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
    COM
    register = RegisterExe.new(commands.split("\n"))
    assert_equal 1, register.largest_register
  end

  def test_it_returns_largest_historical_value
    commands = <<-COM
      b inc 5 if a > 1
      a inc 1 if b < 5
      c dec -10 if a >= 1
      c inc -20 if c == 10
    COM
    register = RegisterExe.new(commands.split("\n"))
    assert_equal 10, register.largest_historical_value
  end
end

register_exe = RegisterExe.new(File.read("./inputs/day8.txt").split("\n"))
puts register_exe.largest_register
puts register_exe.largest_historical_value
