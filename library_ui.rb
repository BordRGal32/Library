require './lib/book'
require './lib/author'
require './lib/catalog'
require 'pg'

DB = PG.connect({:dbname => 'library'})

def main_menu
  system('clear')
  puts "**********************************"
  puts "*    WELCOME TO OUR LIBRARY!     *"
  puts "*  A - Author Menu               *"
  puts "*  B - Book Menu                 *"
  puts "*  C - List all books by Author  *"
  puts "*  X - Exit                      *"
  puts "**********************************"

  user_input = gets.downcase.chomp

  case user_input
  when 'a'
    author_menu
  when 'b'
    book_menu
  when 'c'
    list_all_books
  when 'x'
    puts "We will miss you oh so much."
  else
    idiot_menu
  end
end

def book_menu
  system('clear')
  puts "**********************************"
  puts "*  L - to list all book          *"
  puts "*  A - to add a new book         *"
  puts "*  D - to delete a book          *"
  puts "*  X - Exit                      *"
  puts "**********************************"
  user_input = gets.chomp.downcase
  case user_input
  when 'l'
    list_book_menu
  when 'a'
    add_book_menu
  when 'd'
    delete_book_menu
  end
end

def list_book_menu
  list_all_books
  puts "Press 'a' to list all of the authors for this book"
  puts "Press 'b' to return to the Book menu."
  user_input = gets.chomp
  case user_input
  when 'a'
    puts "Please enter the list number of the book."
    book_index = gets.chomp
    current_book_id = Book.all[book_index.to_i-1].id
    authors = Catalog.book_authors_join(current_book_id)
    authors.each do |author|
      puts "#{author[1]}, #{author[0]}"
    end
    puts "Press enter to return to main menu."
    gets
    main_menu
  when 'a'
    book_menu
  end
end


def author_menu
  system('clear')
  puts "**********************************"
  puts "*  L - to list all authors       *"
  puts "*  A - to add a new author       *"
  puts "*  D - to delete an author       *"
  puts "*  X - Exit                      *"
  puts "**********************************"

  user_input = gets.chomp.downcase
  case user_input
  when 'l'
    list_author_menu
  when 'a'
    add_author_menu
  when 'd'
    delete_author_menu
  end
end

def list_author_menu
  list_all_authors
  puts "Press 'b' to list all of the books for an author"
  puts "Press 'a' to return to the Author menu."
  user_input = gets.chomp
  case user_input
  when 'b'
    puts "Please enter the list number of the author"
    author_index = gets.chomp
    current_author_id = Author.all[author_index.to_i-1].id
    books = Catalog.author_books_join(current_author_id)
    books.each do |book|
      puts "#{book[0]}, #{book[1]}, #{book[2]}"
    end
    puts "Press enter to return to main menu."
    gets
    main_menu
  when 'a'
    author_menu
  end
end

def add_author_menu
  puts "What is the author's first name?"
  author_first_name = gets.chomp
  puts "What is the author's last name?"
  author_last_name = gets.chomp
  current_author = Author.create({:first_name => author_first_name, :last_name => author_last_name})
  puts "Congratulations! #{author_first_name} #{author_last_name} was successfully added to the database."
  puts "☂☂☂☂☂"
  puts "Press 'a' to add a new book to #{author_first_name} #{author_last_name}'s books."
  puts "Press 'b' to go back to the author menu."
  puts "Press 'm' to go back to the main menu."
  user_input = gets.chomp

  case user_input
  when 'a'
    add_book_given_author(current_author)
  when 'b'
    author_menu
  when 'm'
    main_menu
  end
end

def add_book_given_author(current_author)
  puts "What is the book's title?"
  new_book_name = gets.chomp
  puts "What is the book's genre?"
  new_book_genre = gets.chomp
  new_book = Book.create({:name => new_book_name, :category => new_book_genre})
  Catalog.create({:author_id => current_author.id, :book_id => new_book.id})
  puts "YAY! You added a book."
  puts "Enter 'a' to add another book to this author."
  puts "Enter 'b' to go back."

  user_input = gets.chomp

  case user_input
  when 'a'
    add_book_given_author(current_author)
  when 'b'
    author_menu
  end
end

def add_book_menu
  puts "Please enter the title of the book you want to add"
  @book_title = gets.chomp
  puts "Please enter the genre of the book"
  @book_genre = gets.chomp
  @new_book = Book.create({:name => @book_title, :category => @book_genre})
  add_author_to_book(@new_book)
end

def add_author_to_book(new_book)

puts "Please enter the last name of the author"
  @author_last = gets.chomp
  if Author.all.select{ |all| all.last_name == @author_last}.length == 0
    @new_book.delete
    puts "this author does not exist. Please enter the author before adding the book"
    add_author_menu
  end

  Author.all.each_with_index do |author, index|
    if @author_last == author.last_name
      puts "#{index + 1}: #{author.first_name}"
    end
  end

  puts "Which one is your author or 'n' if it doesn't exist."
  author_index = gets.chomp
  if author_index == 'n'
    puts "Please add author. Press Enter."
    gets
    add_author_menu
  elsif /\d/.match(author_index) != nil && (author_index.to_i - 1 <= Author.all.length && author_index.to_i - 1 >= 0)
    Catalog.create({:author_id => Author.all[author_index.to_i - 1].id, :book_id => new_book.id})
    puts "#{new_book.name} has been added."
    puts "Press 'a' to add another author to the current book."
    puts "Press 'b' to add another book."
    puts "Press 'm' to go back to main menu"

    user_input = gets.chomp
    case user_input
    when 'a'
      add_author_to_book(new_book)
    when 'b'
      add_book_menu
    when 'm'
      main_menu
    else
      idiot_menu
    end
  else
    puts "Not a valid input"
    add_book_menu
  end
end

def idiot_menu
  puts "**********************************"
  puts "*    YOU ARE AN IDIOT            *"
  puts "* A REALLY BIG IDIOT             *"
  puts "*  YOU SHOULD PRACTICE READING   *"
  puts "*  PRESS ENTER TO TRY AGAIN      *"
  puts "**********************************"
  gets
  main_menu
end

def list_all_authors
  Author.all.each_with_index do |author, index|
    puts "#{index + 1}: #{author.last_name}, #{author.first_name}"
  end
end

def list_all_books
  Book.all.each_with_index do |book, index|
    puts "#{index + 1}: #{book.name}."
  end
end

def delete_book_menu
list_all_books
puts "Please enter the list number of the book you would like to delete"
book_index = gets.chomp.to_i
book = Book.all[book_index-1]
Catalog.delete_book(book.id)
book.delete
puts "#{book.name} has been deleted!"
puts "Press 'd' to delete another book."
puts "Press 'm' to return to main menu"

user_input = gets.chomp

  case user_input
  when 'd'
    delete_book_menu
  when 'm'
    main_menu
  end
end

def delete_author_menu
list_all_authors
puts "Please enter the list number of the author you would like to delete"
author_index = gets.chomp.to_i
author = Author.all[author_index-1]
Catalog.delete_author(author.id)
author.delete
puts "#{author.first_name} has been deleted!"
puts "Press 'd' to delete another author."
puts "Press 'm' to return to main menu"

user_input = gets.chomp

  case user_input
  when 'd'
    delete_author_menu
  when 'm'
    main_menu
  end
end

main_menu
