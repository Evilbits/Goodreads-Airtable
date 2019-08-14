require 'logger'
require 'goodreads'
require 'airrecord'
require_relative 'goodreads_client'
require_relative 'book'

class Importer
  USER_ID = 96047798
  READ    = 'read'
  TO_READ = 'to-read'

  def self.import_from_goodreads
    existing_books = Book.all
    shelf = self.get_shelf(TO_READ)
    logger.info("Starting shelf: #{TO_READ}")
    self.import_from_shelf(shelf, existing_books)
    logger.info("Starting shelf: #{READ}")
    shelf = self.get_shelf(READ)
    self.import_from_shelf(shelf, existing_books, true)
  end

  private

    def self.import_from_shelf(shelf, existing_books, mark_read = false)
      books        = shelf.books
      books_length = books.length
      books.each_with_index do |shelf_book, idx|
        book = shelf_book.book
        existing_book = existing_books.find { |other| other["ISBN"] == book.isbn13 }
        personal_rating = shelf_book.rating.to_i
        logger.info("#{idx+1}/#{books_length} - #{book.title}")
        if existing_book
          existing_book.create_from_goodreads(book, mark_read, personal_rating)
        else
          Book.new("Title" => book.title).create_from_goodreads(book, mark_read, personal_rating)
        end
      end
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.get_shelf(shelf_name)
      GoodreadsClient::Client.shelf(USER_ID, shelf_name)
    end
end

Airrecord.api_key = ENV['AIRTABLE_KEY']
Importer.import_from_goodreads
