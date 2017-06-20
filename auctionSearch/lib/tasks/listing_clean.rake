desc "delete finished listings"
task :clean_listings => :environment do
	require 'nokogiri'
	require 'open-uri'

	Search.all.each do |search|
		
		search.listings.each do |listing|			
			if listing.url.include?("yahoo")
				#temporary fix code for deleting old url style/url doubles from y!auc's change 08/04/17
				#if (listing.url =~ /page\d{1,2}/ )
				#	puts "double found, deleting..."
				#	listing.delete
				#elsif
				begin
				stream = open(listing.url)
				rescue OpenURI::HTTPError => e
					if e.message == "404 Not Found"
						puts "Note: received a 404 error. Deleting listing [#{listing.title}] from yahoo..."
						listing.delete
					else 
						puts "There was an error #{e} with listing #{listing.url}. Continuing..."
						#if we choose to abort
						#next
					end
				end

				if Nokogiri::HTML(stream).css("div.ProductInformation").empty?
					puts "deleting finished listing [#{listing.title}] from yahoo."
					listing.delete
				end

			elsif listing.url.include?("mbok")
				newurl = listing.url
				#legacy support for old mbok urls http->https
				unless listing.url.include?("https")
					newurl.insert(4,'s')
					#temporary fix code for deleting url doubles from mbok's change from http->https
					#if search.listings.exists?(url: newurl)
					#	puts "double found, deleting..."
					#	listing.delete
					#end
				end
				begin
				stream = open(newurl)
				rescue OpenURI::HTTPError => e
					if e.message == "404 Not Found"
						puts "Note: received a 404 error. Deleting listing [#{listing.title}] from mbok..."
						listing.delete
					else 
						puts "There was an error #{e} with listing #{listing.url}. Continuing..."
					end
				end
				unless Nokogiri::HTML(stream).css("div.announceArea").empty?
					puts "deleting finished listing [#{listing.title}] from mbok."
					listing.delete
				end
			end
		end
	end
end