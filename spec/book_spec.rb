require 'spec_helper'

describe Book do
  it 'initializes with a name and author id and category and id' do
    test_book = Book.new({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
    test_book.should be_an_instance_of Book
    test_book.name.should eq "Book Title"
    test_book.category.should eq "Sci-Fi"
    test_book.status.should eq false
    test_book.id.should eq 1
  end
  describe '.all' do
    it 'creates an instance of book for every piece of data in the book table in the library database' do
      test_book = Book.new({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
      test_book.save
      Book.all.should eq [test_book]
    end
  end
  describe '#save' do
    it 'saves instances of book to the book table in the library database' do
    test_book = Book.new({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
    test_book.save
    Book.all.should eq [test_book]
    end
  end
  describe '==' do
    it 'says that two objects are equal if their attributes are equal' do
      test_book = Book.new({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
      test_book2 = Book.new({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
      test_book.should eq test_book2
    end
  end
  describe '.create' do
    it 'initializes and saves at the same time' do
      test_book = Book.create({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
      test_book.should be_an_instance_of Book
    end
  end
  describe '#modify' do
    it 'allows a user to update the titlle, category, and status of a book' do
      test_book = Book.create({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
      test_book.modify({'name' => "Awesome Book"})
      test_book.name.should eq "Awesome Book"
    end
    it 'allows a user to update the titlle, category, and status of a book' do
      test_book = Book.create({:name => "Book Title", :category => "Sci-Fi", :status => false, :id => 1})
      test_book.modify({'category' => "Fiction"})
      test_book.category.should eq "Fiction"
    end
  end
end
