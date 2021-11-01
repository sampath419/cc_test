# frozen_string_literal: true

def fetch_credit_card
  puts 'Please enter the input file path with filename with extension .txt'
  file = gets.chomp
  user = array_to_user file_to_array(file)
  output user
end

def file_to_array(file)
  lines = []
  File.readlines(file).each do |line|
    lines << line.chomp.split(' ')
  end
  lines
end

def array_to_user(lines)
  user = {}
  lines.each do |e|
    user[e[1]] ||= { 'is_valid_card_number' => false, 'balance' => 0 }
    if e.size == 4
      user[e[1]]['balance'] = e[3][1..-1].to_i
      user[e[1]]['is_valid_card_number'] = is_valid_card? e[2]
    elsif user[e[1]]['is_valid_card_number'] && e[0] == 'Charge'
      user[e[1]]['balance'] = user[e[1]]['balance'] + e[2][1..-1].to_i
    elsif user[e[1]]['is_valid_card_number'] && e[0] == 'Credit'
      user[e[1]]['balance'] = user[e[1]]['balance'] - e[2][1..-1].to_i
    end
  end
  user
end

def is_valid_card?(card_number)
  return false if card_number.length > 19

  check_luhn card_number
end

def check_luhn(card_number)
  digit_sum = 0
  card_number.reverse.split('').each_with_index do |e, index|
    if index.even?
      digit_sum += e.to_i
    else
      temp = e.to_i * 2
      digit_sum += (temp > 9 ? temp.to_s.split('').map(&:to_i).sum : temp)
    end
  end
  (digit_sum % 10).zero?
end

def output(user)
  Hash[user.sort_by { |key, _val| key }].each do |key, value|
    p value['is_valid_card_number'] ? "#{key}: $#{value['balance']}" : "#{key}: error"
  end
end

fetch_credit_card
