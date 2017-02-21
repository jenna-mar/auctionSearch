desc "delete finished listings"
task :clean_listings => :environment do
	require 'nokogiri'
	require 'open-uri'

	Search.all.each do |search|
		
		search.listings.each do |listing|			
			if listing.url.include?("yahoo")
				if Nokogiri::HTML(open(listing.url)).css("div.ProductInformation").empty?
					puts "deleting finished listing [#{listing.title}] from yahoo."
					listing.delete
				end
			elsif listing.url.include?("mbok")
				newurl = listing.url
				#legacy support for old mbok urls http->https
				unless listing.url.include?("https")
					newurl.insert(4,'s')
					#temporary fix code for deleting url doubles from mbok's change from http->https
					if search.listings.exists?(url: newurl)
						puts "double found, deleting..."
						listing.delete
					end
				end
				#puts newurl
				if Nokogiri::HTML(open(newurl)).css("div.announceArea").empty?
					puts "deleting finished listing [#{listing.title}] from mbok."
					listing.delete
				end
			end
		end
	end
end