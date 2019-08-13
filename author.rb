class Author < Airrecord::Table
  self.base_key = 'apppDHg8PasCSBhei'
  self.table_name = 'Authors'

  def create_from_goodreads(author)
    self['Name'] = author.name
    self.save
  end
end
