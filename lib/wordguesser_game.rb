
class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.


  # Get a word from remote "random word" service


  attr_accessor :word, :guesses, :wrong_guesses
 
  def initialize(word)
    @word = word
    @guesses =''
    @wrong_guesses = ''
  end


  def guess(letter)
   
    if letter == ''
      raise ArgumentError
    end

    #if letter == nil
     # raise ArgumentError
    #end

    return false if @guesses.include?(letter.downcase) || @wrong_guesses.include?(letter.downcase)


    if !letter.match?(/\A[a-zA-Z]+\z/)
      raise ArgumentError
    end
 
    if word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
 
    true
  end
 
  def word_with_guesses
    return_str = ''
    word.each_char do |chr|
      if @guesses.include?(chr)
        return_str += chr
      else
        return_str += '-'
      end
    end
    return_str
  end




  def check_win_or_lose


    if @guesses.length + @wrong_guesses.length >= 7
      return :lose
    end


    return_str = ''
    word.each_char do |chr|
      if @guesses.include?(chr)
        return_str += chr
      else
        return_str += '-'
      end
    end


    if return_str == word
      return :win
    end


    :play


  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port) do |http|
      return http.post(uri, "").body
    end
  rescue
    # fallback if the service is unreachable (Codio, Heroku, etc.)
    return "fallback"
  end
end  
