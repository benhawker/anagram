#!/usr/bin/env ruby
require 'yaml'

input_word = ARGV.first
file = File.read("./dictionary.yaml")

src = YAML.parse(file)
src.select do |node|
  if node.is_a?(Psych::Nodes::Scalar)
    node.quoted = true
    node.style  = Psych::Nodes::Scalar::DOUBLE_QUOTED
  end
end

if input_word.nil?
  STDERR.puts "Please provide a word as the first argument."
  exit(1)
end

# Approach: Build a {} with...
# - Key: sorted word
# - Value: array of words that sort to the given key
def find(word_list:, input_word:)
  anagrams = {}
  sorted_input_word = input_word.chars.sort_by(&:downcase).join

  word_list.each do |word|
    sorted_word = word.chars.sort_by(&:downcase).join
    if anagrams[sorted_word]
      anagrams[sorted_word] << word
    else
      anagrams[sorted_word] = [word]
    end
  end

  puts anagrams[sorted_input_word]
end

find(input_word: input_word, word_list: src.to_ruby)