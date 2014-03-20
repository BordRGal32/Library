require 'book'

describe Book do
  it 'initializes with a name and author id and category and id' do
    test_book = Book.new({:name => "Book Title", :author_id => 3, :category => "Sci-Fi", :id => 1})
    test_book.should be_an_instance_of Book
  end
end
