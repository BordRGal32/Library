class Author
  attr_reader :first_name, :last_name, :id

  def initialize(attributes)
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @id = attributes[:id]
    @attributes = ['first_name', 'last_name']
  end

  def self.all
    results = DB.exec("SELECT * FROM authors;")
    authors = []
    results.each do |result|
      first_name = result['first_name']
      last_name = result['last_name']
      id = result['id']
      authors << Author.new({:first_name => first_name, :last_name => last_name, :id => id})
    end
    authors
  end

  def self.create(attributes)
    author = Author.new(attributes)
    author.save
    author
  end

  def save
    result = DB.exec("INSERT INTO authors (first_name, last_name) VALUES ('#{@first_name}', '#{@last_name}') RETURNING id;")
    @id = result.first['id']
  end

  def ==(another_author)
    self.first_name == another_author.first_name && self.last_name == another_author.last_name
  end

  def modify(new_attributes)
    new_attributes.each do |column_name, attribute|
      DB.exec("UPDATE authors SET #{column_name} = '#{attribute}' WHERE id = #{@id};")
    end
    @attributes.each do |attribute|
      if new_attributes[attribute] != nil
        new_attribute = new_attributes[attribute]
        change_instance(attribute, new_attribute)
      end
    end
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{id}")
  end

  def change_instance(attribute, new_attribute)
    var_name = "@#{attribute}"
    self.instance_variable_set(var_name, new_attribute)
  end
end
