require 'pry'
class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography


  def self.create_table
    sql = """CREATE TABLE students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    tagline TEXT,
    github TEXT,
    twitter TEXT,
    blog_url TEXT,
    image_url TEXT,
    biography TEXT
    );"""

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def insert
    sql = """INSERT INTO students(name, tagline, github, twitter, blog_url, image_url, biography) VALUES (?, ?, ?, ?, ?, ?, ?);"""
    DB[:conn].execute(sql, name, tagline, github, twitter, blog_url, image_url, biography)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]

  end
  require 'pry'
  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.tagline = row[2]
    new_student.github = row[3]
    new_student.twitter = row[4]
    new_student.blog_url = row[5]
    new_student.image_url = row[6]
    new_student.biography = row[7]
    new_student

  end

  require 'pry'
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    results = DB[:conn].execute(sql, name)

    results.map { |row| self.new_from_db(row) }.first # .first is equal to results[0]. results returns an array within an array. we want to flatten it.

  end

  def update
    sql=<<-SQL
    UPDATE students
    SET name=?, tagline=?, github=?, twitter=?, blog_url=?, image_url=?, biography=?
    WHERE id = ?
    SQL
    DB[:conn].execute(sql, name, tagline, github, twitter, blog_url, image_url, biography, id)
  end

  def persisted?
    !!id
  end

  def save

    if persisted? ? update : insert
    end
  end

end
