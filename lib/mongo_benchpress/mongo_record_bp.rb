require 'mongo_record'
require File.join( File.dirname(__FILE__), 'base' )

module MongoBenchpress
  class MongoRecordBp < Base

    def orm_classname; 'MongoRecord'; end
    self.benchmarks = {
      :insert => Proc.new { |coll, object, i, klass|
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
        coll.find(:all, :criteria => {'x' => criteria}).each{}
       }
    }

    def connect( options = {} )
      super( options )
      MongoRecord::Base.connection = self.db
      require File.join( File.dirname(__FILE__), 'models', 'mongo_record_models' )
    end
  end
end
