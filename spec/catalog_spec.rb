require 'spec_helper'

describe Catalog do
  it 'initializes with a name and Catalog id and category and id' do
    test_catalog = Catalog.new({:author_id => 2, :book_id => 1, :id => 1})
    test_catalog.should be_an_instance_of Catalog
    test_catalog.author_id.should eq 2
    test_catalog.book_id.should eq 1
    test_catalog.id.should eq 1
  end
  describe '.all' do
    it 'creates an instance of Catalog for every piece of data in the Catalog table in the library database' do
      test_catalog = Catalog.new({:author_id => 2, :book_id => 1, :id => 1})
      test_catalog.save
      Catalog.all.should eq [test_catalog]
    end
  end
  describe '#save' do
    it 'saves instances of Catalog to the Catalog table in the library database' do
    test_catalog = Catalog.new({:author_id => 2, :book_id => 1, :id => 1})
    test_catalog.save
    Catalog.all.should eq [test_catalog]
    end
  end
  describe '==' do
    it 'says that two objects are equal if their attributes are equal' do
      test_catalog = Catalog.new({:author_id => 2, :book_id => 1, :id => 1})
      test_catalog2 = Catalog.new({:author_id => 2, :book_id => 1, :id => 1})
      test_catalog.should eq test_catalog2
    end
  end
  describe '.author_books_join' do
    it 'finds the books that are related to an author' do
      test_book = Book.create({:name => "Book", :category => "Awesome", :status => false})
      test_book_id = test_book.id
      test_author = Author.create({:first_name => "Jane", :last_name => "Poop"})
      test_author_id = test_author.id
      test_catalog = Catalog.create({:author_id => test_author_id, :book_id => test_book_id})
      Catalog.author_books_join(test_author_id).should eq [["Book", "Awesome", "f"]]
    end
  end
  describe '.books_author_join' do
    it 'finds the authors that are related to a book' do
      test_book = Book.create({:name => "Book", :category => "Awesome", :status => false})
      test_book_id = test_book.id
      test_author = Author.create({:first_name => "Jane", :last_name => "Poop"})
      test_author2 = Author.create({:first_name => "Dog", :last_name => "Cat"})
      test_author_id = test_author.id
      test_author_id2 = test_author2.id
      test_catalog = Catalog.create({:author_id => test_author_id, :book_id => test_book_id})
      test_catalog2 = Catalog.create({:author_id => test_author_id2, :book_id => test_book_id})
      Catalog.book_authors_join(test_book_id).should eq [["Jane", "Poop"], ["Dog", "Cat"]]
    end
  end
  describe '.delete_books' do
    it 'allows a user to delete a book' do
      test_book = Book.create({:name => "Book Title", :category => "Sci-Fi", :status => false})
      test_book_id = test_book.id
      test_author = Author.create({:first_name => "Lauren", :last_name => "Yeiser"})
      test_author_id = test_author.id
      test_catalog = Catalog.create({:author_id => test_author_id, :book_id => test_book_id})
      Catalog.delete_book(test_book_id)
      Catalog.all.length.should eq 0
    end
  end
  describe '.delete_author' do
    it 'allows a user to delete authors' do
      test_book = Book.create({:name => "Book Title", :category => "Sci-Fi", :status => false})
      test_book_id = test_book.id
      test_author = Author.create({:first_name => "Lauren", :last_name => "Yeiser"})
      test_author_id = test_author.id
      test_catalog = Catalog.create({:author_id => test_author_id, :book_id => test_book_id})
      Catalog.delete_author(test_author_id)
      Catalog.all.length.should eq 0
    end
  end
end
