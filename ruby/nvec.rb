require 'test/unit'

class MlVec
  attr_accessor :dim

  def initialize(arr)
    @data = arr
    @dim = arr.length
  end

# Higher Order Functions
  def map(fn, other = nil)
    arr = MlVec.new(Array.new(@dim))
    if other
      if other.is_a? Numeric
        (0...@dim).zip(@data).each() do |index,val|
          arr[index] = fn.call(val,other)
        end
      else
        (0...@dim).zip(@data,other) do |index,a,b|
          arr[index] = fn.call(a,b)
        end
      end
    else
      (0...@dim).zip(@data).each() do |index,val|
        arr[index] = fn.call(val)
      end
    end
    arr
  end

  def fold(fn, other = nil, default = 0)
    if other
      if other.is_a? Numeric
        @data.each() do |val|
          default = fn.call(val,other,default)
        end
      else
        @data.zip(other).each() do |a,b|
          default = fn.call(a,b,default)
        end
      end
    else
      @data.each() do |val|
        default = fn.call(val,default)
      end
    end
    default
  end

  def add(other)
    map(lambda {|a,b| a + b }, other)
  end

  def sub(other)
    map(lambda {|a,b| a - b }, other)
  end

  def mul(other)
    map(lambda {|a,b| a * b }, other)
  end

  def div(other)
    if other.is_a? Numeric
      mul(1.0 / other)
    else
      map(lambda {|a,b| a / b }, other)
    end
  end

  def dot(other)
    fold(lambda {|a,b,c| a * b + c }, other, 0)
  end

  def +(other)
    add(other)
  end

  def -(other)
    sub(other)
  end

  def *(other)
    mul(other)
  end

  def /(other)
    div(other)
  end

  def each
    @data.each() {|a| yield a }
  end

  def ==(other)
    @data.length == fold(lambda{|a,b,c| c + (a == b ? 1 : 0)}, other, 0)
  end

  def [](index)
    @data[index]
  end

  def []=(index,val)
    @data[index] = val
  end

  def print_vec()
    puts("Vector: #{data.to_s}")
  end
end

class TestVec < Test::Unit::TestCase
    @@a = MlVec.new([1.0,1.0,1.0,1.0])
    @@b = MlVec.new([2.0,3.0,4.0,5.0])

  def test_eq
    #ea = MlVec.new([1.0,1.0,1.0,1.0])
    assert(@@a == @@a)
  end

  def test_add
    c = @@a + @@b
    assert(c == MlVec.new([3.0,4.0,5.0,6.0]))
  end

  def test_mult
    c = @@b * @@b
    assert(c == MlVec.new([4.0,9.0,16.0,25.0]))
  end

  def test_scalar_mult
    c = @@a * 2
    assert(c == MlVec.new([2.0,2.0,2.0,2.0]))
  end

  def test_divide
    c = @@b / @@b
    assert(c == @@a)
  end

  def test_dot
    c = @@a.dot(@@b)
    assert(c == 14.0)
  end
end
