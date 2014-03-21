class Catalog
 attr_reader :author_id, :book_id, :id

  def initialize(attributes)
    @author_id = attributes[:author_id]
    @book_id = attributes[:book_id]
    @id = attributes[:id]
    @attributes = ['author_id', 'book_id']
  end

  def self.all
    results = DB.exec("SELECT * FROM catalogs;")
    catalog = []
    results.each do |result|
      author_id = result['author_id'].to_i
      book_id = result['book_id'].to_i
      id = result['id']
      catalog << Catalog.new({:author_id => author_id, :book_id => book_id, :id => id})
    end
    catalog
  end

  def self.create(attributes)
    author = Catalog.new(attributes)
    author.save
    author
  end

   def self.author_books_join(user_id)
    results = DB.exec("select books.* from
    authors join catalogs on (authors.id = catalogs.author_id)
            join books on (catalogs.book_id = books.id)
    where authors.id = #{user_id};")
    books = []
    results.each do |result|
      books << ["#{result['name']}", "#{result['category']}", "#{result['status']}"]
    end
    books
  end
  def self.book_authors_join(user_id)
    results = DB.exec("select authors.* from books join catalogs on (books.id = catalogs.book_id) join authors on (catalogs.author_id = authors.id) where books.id = #{user_id};")
    authors = []
    results.each do |result|
      authors << ["#{result['first_name']}", "#{result['last_name']}"]
    end
    authors
  end

  def save
    result = DB.exec("INSERT INTO catalogs (author_id, book_id) VALUES ('#{@author_id}', '#{@book_id}') RETURNING id;")
    @id = result.first['id']
  end

  def ==(another_catalog)
    self.author_id == another_catalog.author_id && (self.book_id == another_catalog.book_id && self.id == another_catalog.id)
  end

  def self.delete_book(book_id)
    DB.exec("DELETE FROM catalogs where book_id = '#{book_id}'")
  end

  def self.delete_author(author_id)
    DB.exec("DELETE FROM catalogs where author_id = '#{author_id}'")
  end
end
