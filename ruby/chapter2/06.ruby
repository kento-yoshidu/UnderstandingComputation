# 変数の実装

class Number < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<< #{self} >>"
  end

  def reducible?
    false
  end
end

class Add < Struct.new(:left, :right)
  def to_s
    "(#{left} + #{right})"
  end

  def inspect
    "<< #{self} >>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value + right.value)
    end
  end
end

class Multiply < Struct.new(:left, :right)
  def to_s
    "(#{left} * #{right})"
  end

  def inspect
    "<< #{self} >>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value * right.value)
    end
  end
end

# 第二引数にハッシュ形式の変数をとる
class Machine < Struct.new(:expression, :environment)
  def step
    self.expression = expression.reduce(environment)
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
  puts expression
  end
end

class Boolean < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    false
  end
end

class LessThan < Struct.new(:left, :right)
  def to_s
    "<< #{left} < #{right} >>"
  end

  def inspect
    "<< #{self} >>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      LessThan.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThan.new(left, right.reduce(environment))
    else
      Boolean.new(left.value < right.value)
    end
  end
end

class Variable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "<< #{self} >>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end

Machine.new(
  Add.new(Variable.new(:x), Variable.new(:y)),
  {
    x: Number.new(3),
    y: Number.new(5)
  }
).run

=begin
(x + y)
(3 + y)
(3 + 5)
8
=end
