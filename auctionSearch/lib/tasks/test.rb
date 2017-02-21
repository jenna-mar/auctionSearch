require 'nokogiri'
require 'open-uri'
	
	# declare url constants
	YAUC = "http://auctions.search.yahoo.co.jp/search?"
	MBOK = "https://www.mbok.jp/_l?"
	CATAPY = "&auccat=2084229923"
	CATAPM = "&c=100000509"
	CATBM = "&c=100000731"
	CATALM = "&c=150003124"

	#Search.all.each do |search|
		#message = "Searching for #{search.name}"
		#if (search.site.empty? || search.site == "Yahoo! Auctions")
		#	puts "#{message} on Yahoo! Auctions..."
		#	findListingsYahoo(search)
		#end
		#if (search.site.empty? || search.site == "Mbok")
		#	puts "#{message} on Mbok..."
		#	findListingsMbok(search)
		#end
	#end
	doc = Nokogiri::HTML(open(MBOK))