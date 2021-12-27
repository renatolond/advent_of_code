# frozen_string_literal: true

$digits = "93151411711211".chars
# w3 = w2 + 4
# w6 = w5 - 3
# w8 = w7 + 6
# w10 = w9
# w11 = w4 + 1
# w12 = w1 -2
# w13 = w0 - 8
def next_digit
  d = $digits.shift.to_i
  puts d
  d
end

stack = [0]
idx = 0
loop do
  w = next_digit
  x = stack.last

  case idx
  when 0
    x += 11
  when 1
    x += 12
  when 2
    x += 10
  when 3
    stack.pop
    x += -8
  when 4
    x += 15
  when 5
    x += 15
  when 6
    stack.pop
    x += -11
  when 7
    x += 10
  when 8
    stack.pop
    x += -3
  when 9
    x += 15
  when 10
    stack.pop
    x += -3
  when 11
    stack.pop
    x += -1
  when 12
    stack.pop
    x += -10
  when 13
    stack.pop
    x += -16
  else
    raise "oh no #{idx}"
  end
  puts "#{x} == #{w}"
  if x != w
    y = w

    case idx
    when 0
      y += 8
    when 1
      y += 8
    when 2
      y += 12
    when 3
      y += 10
    when 4
      y += 2
    when 5
      y += 8
    when 6
      y += 4
    when 7
      y += 9
    when 8
      y += 10
    when 9
      y += 3
    when 10
      y += 7
    when 11
      y += 7
    when 12
      y += 2
    when 13
      y += 2
    else
      raise "oh no #{idx}"
    end

    stack.push(y)
  end
  puts "stack: #{stack.join(", ")}"
  idx += 1
  break if idx >= 14
end
