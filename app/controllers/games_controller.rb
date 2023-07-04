require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (('a'..'z').to_a * 3).sample(10)
    @time_start = Time.now
  end

  def score
    @word = (params[:word] || "").upcase
    @letters = params[:letters].split
    @included = word_in_grid?
    @english_word = word_english?
    @diff_in_seconds = (Time.now - Time.parse(params[:time_start])).floor
    @score = calc_score
  end

  private

  def word_in_grid?
    letters = @letters.dup
    @word.downcase.chars.each do |letter|
      return false unless letters.include?(letter)

      letters.delete(letter)
    end
    true
  end

  def word_english?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = JSON.parse(URI.open(url).read)
    response['found']
  end

  def calc_score
    ## the lower the seconds, the better
    ## the higher the letter count, the better
    word_length = @word.length
    (word_length * 100) - @diff_in_seconds
  end
end
