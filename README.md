![image showing airtable](http://reiler.net/goodreads-airtable.png)

# Goodreads-Airtable
Fetch your "read" and "to-read" shelves from Goodreads and sync with an Airtable.
Won't work by default unless Airtable is setup with correct associations and attributes.

Remember to add your own Goodreads and Airtable API keys.

[Example](https://airtable.com/shrbnNOGzXUakrXMj/tblpA7w5uCTdnEWrt/viwNqVN94B5r9jAUY?blocks=hide)

# Usage
Pull to server and setup environment variables.

Setup Airtable.

Run in cronjob.

# Cron setup
First run `rvm cron setup` if using RVM.

Afterwards setup the crontab with your ENV vars like so.
This will run the script every 30 minutes.
```
GOODREADS_TOKEN=""
GOODREADS_SECRET=""
AIRTABLE_KEY=""
0,30 * * * * ruby /path/to/script/importer.rb
```
