class Book
  attr_reader :name, :category, :status, :id

  def initialize(attributes)
    @attributes = ['name', 'category', 'status', 'id']
    @name = attributes[:name]
    @category = attributes[:category]
    @status = attributes[:status]
    @id = attributes[:id]
  end

  def self.all
    results = DB.exec("SELECT * FROM books;")
    books = []
    results.each do |result|
      name = result['name']
      category = result['category']
      status = result['status']
      id = result['id']
      books << Book.new({:name => name, :category => category, :status => status, :id => id})
    end
    books
  end

  def save
    result = DB.exec("INSERT INTO books (name, category, status) VALUES ('#{@name}', '#{@category}', '#{@status}') RETURNING id;")
    @id = result.first['id']
  end

  def self.create(attributes)
    book = Book.new(attributes)
    book.save
    book
  end

  def ==(another_book)
    self.name == another_book.name && (self.category == another_book.category && self.id == another_book.id)
  end

  def modify(new_attributes)
    new_attributes.each do |column_name, attribute|
      DB.exec("UPDATE books SET #{column_name} = '#{attribute}' WHERE id = #{@id};")
    end
    @attributes.each do |attribute|
      if new_attributes[attribute] != nil
        new_attribute = new_attributes[attribute]
        change_instance(attribute, new_attribute)
      end
    end
  end

  def change_instance(attribute, new_attribute)
    var_name = "@#{attribute}"
    self.instance_variable_set(var_name, new_attribute)
  end
end
