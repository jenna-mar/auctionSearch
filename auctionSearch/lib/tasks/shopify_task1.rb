################################################################################
# Purpose: Concise script to compute total order revenue (normalized to usd).
#
# Assumptions: No tax on any orders (verified in our case) and total_price_usd 
#              is available on all orders.
#
# Notes: Initially, there were some problems trying to retrieve the json file
#        provided over https due to default behavior in Ruby (can't find root CA
#        certs). This solution assumes that the execution environment does not
#        have this bug in making SSL requests.
#        
#        A previous submission (which attempted to avoid SSL requests) missed
#        the pagination of JSON orders since only the first page was saved
#        locally. Here, we correct this error by leveraging API requests.
################################################################################

require 'json'
require "open-uri"

# declare string constants
BASE_URI = "https://shopicruit.myshopify.com/admin"
ACCESS_TOKEN = "access_token=c32313df0d0ef512ca64d5b336a0d7c6"

# get total orders count
orders_count_uri = "#{BASE_URI}/orders/count.json?#{ACCESS_TOKEN}"
parsed_uri = URI.parse(orders_count_uri).read
json = JSON.parse(parsed_uri)
orders_count = json["count"]

orders = []
page = 1
while orders.length < orders_count
    # iteratively append orders from each json page
    parsed_uri = URI.parse("#{BASE_URI}/orders.json?page=#{page}&#{ACCESS_TOKEN}").read
    json = JSON.parse(parsed_uri)  
    orders.push(*json["orders"])
    page += 1
end

# calculate total revenue in USD
sum_revenue = orders.inject(0) { |sum, order| sum + (order["total_price_usd"].to_f) }
puts "Total revenue: $#{'%.2f' % sum_revenue} USD"
