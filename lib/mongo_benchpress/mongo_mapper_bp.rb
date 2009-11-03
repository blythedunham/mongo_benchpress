require 'mongo_mapper'
require File.join( File.dirname(__FILE__), 'base' )
require File.join( File.dirname(__FILE__), 'models', 'mongo_mapper_models.rb' )


module MongoBenchpress
  class MongoMapperBp < MongoBenchpress::Base

    def orm_classname; 'MongoMapper'; end
    self.benchmarks = {
      :insert => Proc.new { |coll, object, i|
        record = coll.new( object )
        record.x = i
        record.save
      },
      :index_setup => nil,
       :insert_batch => nil,
       :find_one => Proc.new { |coll, x, i|
         coll.find_by_x( x )
       },
       :find => Proc.new { |coll, criteria, i|
         coll.find(:all, :criteria => {'x' => criteria})
       }
    }
    def connect( options = {} )
      super( options )
      ::MongoMapper.connection = self.connection
      ::MongoMapper.database = self.db.name
    end
  end
end
