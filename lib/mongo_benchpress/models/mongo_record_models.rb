
class MongoRecordSmallNone < MongoRecord::Base
  collection_name :small_none
  fields :x
end

class MongoRecordMediumNone < MongoRecord::Base
  collection_name :medium_none
  fields :integer, :number, :boolean, :array, :x
end

class MongoRecordLargeNone < MongoRecord::Base
  collection_name :large_none
  fields :base_url, :total_word_count, :access_time, :meta_tags, :page_structure, :harvested_words, :x
end

class MongoRecordSmallIndex < MongoRecord::Base
  collection_name :small_index
  fields :x
end

class MongoRecordMediumIndex < MongoRecord::Base
  collection_name :medium_index
  fields :integer, :number, :boolean, :array, :x
  index :x
end

class MongoRecordLargeIndex < MongoRecord::Base
  collection_name :large_index
  fields :base_url, :total_word_count, :access_time, :meta_tags, :page_structure, :harvested_words, :x
  index :x
end

class MongoRecordSmallBulk< MongoRecord::Base
  collection_name :small_bulk
  fields :x
end

class MongoRecordMediumBulk < MongoRecord::Base
  collection_name :medium_bulk
  fields :integer, :number, :boolean, :array, :x
end

class MongoRecordLargeBulk < MongoRecord::Base
  collection_name :large_bulk
  fields :base_url, :total_word_count, :access_time, :meta_tags, :page_structure, :harvested_words, :x
end
