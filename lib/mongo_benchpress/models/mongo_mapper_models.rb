class MongoMapperSmallNone   
  include MongoMapper::Document
  database 'small_none'
  key :x
end

class MongoMapperMediumNone
  include MongoMapper::Document
  database 'medium_none'
  key :integer, Integer
  key :number,  Float
  key :boolean, Boolean
  key :array,   Array
  key :x,       Integer
end

class MongoMapperLargeNone 
  include MongoMapper::Document
  database 'large_none'
  key :base_url, String
  key :total_word_count, Integer
  key :access_time, Time
  key :meta_tags, Hash 
  key :page_structure, Hash
  key :harvested_words, Array
  key :x, Integer
end

class MongoMapperSmallIndex
  include MongoMapper::Document
  database 'small_index'
  key :x
  ensure_index :x
end

class MongoMapperMediumIndex
  include MongoMapper::Document
  database 'medium_index'
  key :integer, Integer
  key :number,  Float
  key :boolean, Boolean
  key :array,   Array
  key :x,       Integer
  ensure_index :x
end

class MongoMapperLargeIndex
  include MongoMapper::Document
  database 'large_none'
  key :base_url, String
  key :total_word_count, Integer
  key :access_time, Time
  key :meta_tags, Hash 
  key :page_structure, Hash
  key :harvested_words, Array
  key :x, Integer
  ensure_index :x
end

class MongoMapperSmallBulk
  include MongoMapper::Document
  database 'small_bulk'
  key :x
end

class MongoMapperMediumBulk
  include MongoMapper::Document
  database 'medium_bulk'
  key :integer, Integer
  key :number,  Float
  key :boolean, Boolean
  key :array,   Array
  key :x,       Integer
end

class MongoMapperLargeBulk
  include MongoMapper::Document
  database 'large_bulk'
  key :base_url, String
  key :total_word_count, Integer
  key :access_time, Time
  key :meta_tags, Hash 
  key :page_structure, Hash
  key :harvested_words, Array
  key :x, Integer
end