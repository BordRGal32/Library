require 'spec_helper'

describe Author do
  it 'initializes with a name and author id and category and id' do
    test_author = Author.new({:first_name => "Elizabeth", :last_name => "Tom", :id => 1})
    test_author.should be_an_instance_of Author
    test_author.first_name.should eq "Elizabeth"
    test_author.last_name.should eq "Tom"
    test_author.id.should eq 1
  end
  describe '.all' do
    it 'creates an instance of Author for every piece of data in the Author table in the library database' do
      test_author = Author.new({:first_name => "Elizabeth", :last_name => "Tom", :id => 1})
      test_author.save
      Author.all.should eq [test_author]
    end
  end
  describe '#save' do
    it 'saves instances of Author to the Author table in the library database' do
    test_author = Author.new({:first_name => "Elizabeth", :last_name => "Tom", :id => 1})
    test_author.save
    Author.all.should eq [test_author]
    end
  end
  describe '==' do
    it 'says that two objects are equal if their attributes are equal' do
      test_author = Author.new({:first_name => "Elizabeth", :last_name => "Tom", :id => 1})
      test_author2 = Author.new({:first_name => "Elizabeth", :last_name => "Tom", :id => 1})
      test_author.should eq test_author2
    end
  end
  describe '.create' do
    it 'initializes and saves at the same time' do
      test_author = Author.new({:first_name => "Elizabeth", :last_name => "Tom", :id => 1})
      test_author.should be_an_instance_of Author
    end
  end
  describe '#modify' do
    it 'modifies the data' do
      test_author = Author.create({:first_name => "Lauren", :last_name => "Yeiser"})
      test_author.modify({'first_name' => "Cat"})
      test_author.first_name.should eq "Cat"
    end
  end
  describe '#delete' do
    it 'allows the user to delete an author from the database' do
      test_author = Author.create({:first_name => "Lauren", :last_name => "Yeiser"})
      test_author.delete
      Author.all.should eq []
    end
  end
end
