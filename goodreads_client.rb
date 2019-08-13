class GoodreadsClient
  Client = Goodreads::Client.new(api_key: ENV['GOODREADS_TOKEN'], api_secret: ENV['GOODREADS_SECRET'])
end
