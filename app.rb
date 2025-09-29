require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game]
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  # Show form to start a new game
  get '/new' do
    erb :new
  end

  # Create new game, then redirect to show
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Display current game state
  get '/show' do
    halt redirect('/new') unless @game

    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end
  end

  # Handle guesses
  post '/guess' do
    halt redirect('/new') unless @game

    letter = params[:guess].to_s[0]&.downcase

    if letter.nil? || letter !~ /[a-z]/
      flash[:message] = "Invalid guess."
    elsif @game.guesses.include?(letter) || @game.wrong_guesses.include?(letter)
      flash[:message] = "You have already used that letter."
    else
      begin
        @game.guess(letter)
      rescue ArgumentError
        flash[:message] = "Invalid guess."
      end
    end

    redirect '/show'
  end

  # Winning page
  get '/win' do
    halt redirect('/new') unless @game
    if @game.check_win_or_lose == :win
      erb :win
    else
      redirect '/show'
    end
  end

  # Losing page
  get '/lose' do
    halt redirect('/new') unless @game
    if @game.check_win_or_lose == :lose
      erb :lose
    else
      redirect '/show'
    end
  end

end