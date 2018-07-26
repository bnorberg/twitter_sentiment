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
		    csv << ["tweet", "retweeted_text", "created_date_time", "created_date", "sentiment", "score"]
		  end
		  @tweets.each do |tweet|
		  	if !tweet['retweeted_text'].nil?
		  		get_sentiment(tweet['retweeted_text'])
		  		get_score(tweet['retweeted_text'])
		  	else	
		  		get_sentiment(tweet['text'])
		  		get_score(tweet['text'])
		  	end	
		  	csv << [tweet['text'], tweet['retweeted_text'], tweet['created_at'], tweet['time'], @sentiment, @score]
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
