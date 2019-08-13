require 'goodreads'
require 'byebug'
require 'airrecord'
require_relative 'goodreads_client'
require_relative 'book'

class Importer
  USER_ID = 96047798
  TO_READ = 'to-read'

  def self.import_from_goodreads
    existing_books = Book.all
    shelf = self.get_shelf(TO_READ)
    self.import_from_shelf(shelf, existing_books)
    shelf = self.get_shelf('read')
    self.import_from_shelf(shelf, existing_books, true)
  end

  private

    def self.import_from_shelf(shelf, existing_books, mark_read = false)
      books = shelf.books
      books.each do |shelf_book|
        book = shelf_book.book
        existing_book = existing_books.find { |other| other["ISBN"] == book.isbn13 }
        if existing_book
          existing_book.create_from_goodreads(book, mark_read)
        else
          Book.new("Title" => book.title).create_from_goodreads(book, mark_read)
        end
      end
    end

    def self.get_shelf(shelf_name)
      GoodreadsClient::Client.shelf(USER_ID, shelf_name)
    end
end

Airrecord.api_key = ENV['AIRTABLE_KEY']
Importer.import_from_goodreads
