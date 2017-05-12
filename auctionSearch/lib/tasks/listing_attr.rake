desc "Fetch listing attributes"
task :fetch_listings => :environment do
	require 'nokogiri'
	require 'open-uri'
	
	# declare url constants
	YAUC = "https://auctions.yahoo.co.jp/search/search?"
	MBOK = "https://www.mbok.jp/_l?"
	CATAPY = "&auccat=2084229923"
	CATAPM = "&c=100000509"
	CATBM = "&c=100000731"
	CATALM = "&c=150003124"

	Search.all.each do |search|
		message = "Searching for #{search.name}"
		if (search.site.empty? || search.site == "Yahoo! Auctions")
			puts "#{message} on Yahoo! Auctions..."
			findListingsYahoo(search)
		end
		if (search.site.empty? || search.site == "Mbok")
			puts "#{message} on Mbok..."
			findListingsMbok(search)
		end
	end
end

def findListingsYahoo(search)
	#prepare search term for url request
	searchterm = URI.escape(search.name)

	#begin search based on website
	url = "#{YAUC}p=#{searchterm}&select=22"
	unless search.category.empty?
		if search.category.casecmp("Angelic Pretty") == 0
			url << CATAPY
		else 
			puts "no compatibility with current category at this time."
			return
		end
	end
	#begin searching page, get information
	doc = Nokogiri::HTML(open(url))
	info = doc.css("td.i div.th a")
	if info.empty?
		puts "no results found."
		return
	end
	total_pages = Integer(doc.css("p.total em").xpath('text()').to_s) / 20	

	#for printing
	#info.each{|link| puts "#{link["href"]}, #{link.css("img")[0]["src"]}, #{link.css("img")[0]["alt"]}"}

	#for counting purposes.
	total = 0
	add = ""
	dupcounter = 0
	catch :found_duplicate do
		(0..total_pages).each do |i|

			#truncate search at 3 pages
			break if i > 2

			#adjust url for pagination
			if i > 0 
				if i > 1 then url = url.chomp(add) end
				add = "&b=#{(i * 20) + 1}"
				url << "#{add}"
				info = (Nokogiri::HTML(open(url))).css("td.i div.th a")
			end
			#promoted listings on first page
			#doc.css("th.t1")[0]

			info.each do |l| 
				listing_url = l["href"]
				if search.listings.exists?(url: listing_url)
					dupcounter+=1
					#we don't expect more than 3 promoted listings
					if dupcounter > 3 then throw :found_duplicate end
				else search.listings.create(:title => l.css("img")[0]["alt"], 
									   		:url => l["href"],
									   		:img => l.css("img")[0]["src"])
				total+=1
				end
			end
		end
	end

	#information
	puts "Added #{total} new results."

	#add image for later
	#download = open(info_img[0]["src"])
	#IO.copy_stream(download, 'images/0.jpg')
end

def findListingsMbok(search)
	#prepare search term for url request
	#mbok uses SHIFT-JIS style url notation, which I have problems converting
	if search.name == "メアリーマグダレン"
		searchterm = "%83%81%83A%83%8A%81%5B%83%7D%83O%83_%83%8C%83%93"
	elsif search.name == "レジメン"
		searchterm = "%83%8C%83W%83%81%83%93"
	elsif search.name == "ドーナツ"
		searchterm = "%83h%81%5B%83i%83c"
	elsif search.name == "ユニコーン"
		searchterm = "%83%86%83j%83R%81%5B%83%93"
	elsif search.name == "ベリー"
		searchterm = "%83x%83%8A%81%5B"
	elsif search.name == "チョコ"
		searchterm = "%83%60%83%87%83R"									
	elsif search.name == "まどろみの浪漫"
		searchterm = "%82%DC%82%C7%82%EB%82%DD%82%CC%98Q%96%9F"
	else 
		searchterm = URI.escape(search.name)
	end

	#begin search based on website
	url = "#{MBOK}q=#{searchterm}&o=8"
	unless search.category.empty?
		if search.category.casecmp("Angelic Pretty") == 0
			url << CATAPM
		else 
			puts "no compatibility with current category at this time."
			return
		end
	end
	#begin searching page, get information
	doc = Nokogiri::HTML(open(url))
	info = doc.css("li.item-box a.item-thumb")
	
	if info.empty?
		puts "no results found."
		return
	end

	#for printing
	#info.each{|link| puts "#{link["href"]}, #{link.css("img")[0]["src"]}, #{link.css("img")[0]["alt"]}"}

	#for counting purposes.
	total = 0

	#mbok has 50 listings per page and is less active than Y!auc, 
	#so we will only check the first page.
	info.each do |l| 
		listing_url = l["href"].chomp("_SRC=li_i0")
		#mbok doesn't have promoted listings, so we don't worry about it
		break if search.listings.exists?(url: listing_url)
		
		#otherwise
		search.listings.create(:title => l.css("img")[0]["alt"], 
						   		:url => listing_url,
						   		:img => l.css("img")[0]["src"])
		total+=1
	end

	#information
	puts "Added #{total} new results."
end