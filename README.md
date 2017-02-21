# auctionSearch
Ruby + Rails webpage application for searching Japanese auction websites
<br>
Please be aware that this application is still in development.<br>
<br>
How to use:<br>
The Ruby rake task can obtain information from two major Japanese auction sites: Yahoo! Auctions, and Mbok. Support for other
secondhand websites may be added later.<br>
The database data provided in this repository is an example, and may be deleted.<br>
1. Search terms are added through the web interface - start up the rails server in the auctionSearch directory (search page can be accessed through localhost:3000/searches) and add your desired search terms. Search terms must be at least 3 characters long, category only searches are not available as of yet. Currently only one category (Angelic Pretty) is supported. Search term searches will be made in the specified category (if no category, the entire site will be searched). If no specific site to search is selected, both/all will be searched.<br>
2. Once all desired search terms are added, run the rake task to scrape the auction websites. The first run will take a while.
Note that only up to page 3 on Y!A and page 1 on Mbok will be scraped, the application is not designed for searches with a large number of 
results.<br>
3. Upon running the server and accessing the webpage again, the results from the rake will be available. the index page will display only
results from today's rake, upon clicking the search term all available results will be displayed.<br>
4. For now, the rake task must be run manually to update. The page assumes that it will be run once a day, but you can run it multiple 
times in a day. Regardless, all results obtained from today will be shown on the front/index page.<br>
Removal and cleanup of listings is to come in a future update.
