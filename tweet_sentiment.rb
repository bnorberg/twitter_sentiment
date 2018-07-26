require 'rubygems'
require 'csv'
require 'sentimental'
require 'sanitize'

class TweetSentiment

	def instatiate_sentimental
		@analyzer = Sentimental.new
		@analyzer.load_defaults
		@analyzer.threshold = 0.1
	end

	def load_tweets
		@tweets = CSV.read(ARGV.first, :external_encoding => "iso-8859-1", :internal_encoding => "utf-8",:col_sep => ",", headers:true)
	end

	def write_sentiment_csv
		instatiate_sentimental
		load_tweets
		new_file = ARGV.last
		CSV.open(new_file, 'ab') do |csv|
		  file = CSV.read(new_file,:external_encoding => "iso-8859-1", :internal_encoding => "utf-8",:col_sep => ",")
		  if file.none?
		    csv << ["tweet", "sentiment", "score", "source", "username", "screename", "month", "day", "year", "time"]
		  end
		  @tweets.each do |tweet|
		  	get_sentiment(tweet['tweet'])
		  	get_score(tweet['tweet'])
		  	csv << [tweet['tweet'], @sentiment, @score, Sanitize.fragment(tweet['source']), tweet['username'], tweet['screen_name'], tweet['created_at_month'], tweet['created_at_day'], tweet['created_at_year'], tweet['created_at_time']]
		  end
		end
	end

	def get_sentiment(tweet)
		@sentiment = @analyzer.sentiment(tweet)
	end

	def get_score(tweet)
		@score = @analyzer.score(tweet)
	end

end

sentiments = TweetSentiment.new
sentiments.write_sentiment_csv
