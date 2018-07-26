require 'rubygems'
require 'csv'
require 'sentimental'
require 'sanitize'

class NewsSentiment

	def instatiate_sentimental
		@analyzer = Sentimental.new
		@analyzer.load_defaults
		@analyzer.threshold = 0.1
	end

	def load_files
		files = Dir.glob("#{ARGV.first}/*.txt")
		write_sentiment_csv(files)
	end

	def write_sentiment_csv(files)
		instatiate_sentimental
		new_file = ARGV.last
		CSV.open(new_file, 'ab') do |csv|
		  file = CSV.read(new_file,:external_encoding => "iso-8859-1", :internal_encoding => "utf-8",:col_sep => ",")
		  if file.none?
		    csv << ["title", "publication", "text", "sentiment", "score", "subject"]
		  end
		  files.each do |file|
		  	title = file.split(" - ")[0].split("/")[1]
		  	if title.downcase.include?("ferguson")
		  		subject = "ferguson"
		  	else
		  		subject = "parkland"
		  	end  		 
		  	publication = file.split(" - ")[1].gsub(".txt", "")
		  	text = File.read(file)
		  	puts title
		  	puts "-------------------"
		  	puts text
		  	puts '==================='
		  	get_sentiment(text)
		  	get_score(text)
		  	csv << [title, publication, text, @sentiment, @score, subject]
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

sentiments = NewsSentiment.new
sentiments.load_files
