require 'goodreads'
require 'airrecord'
require_relative 'goodreads_client'
require_relative 'book'

class Importer
  USER_ID    = 96047798
  SHELF_NAME = 'to-read'

  def self.import_from_goodreads
    existing_books = Book.all
    shelf = self.get_shelf
    books = shelf.books
    books.each do |shelf_book|
      book = shelf_book.book
      existing_book = existing_books.find { |other| other["ISBN"] == book.isbn13 }
      if existing_book
        existing_book.create_from_goodreads(book)
      else
        Book.new("Title" => book.title).create_from_goodreads(book)
      end
    end
  end

  private

    def self.get_shelf
      GoodreadsClient::Client.shelf(USER_ID, SHELF_NAME)
    end
end

Airrecord.api_key = ''
Importer.import_from_goodreads
