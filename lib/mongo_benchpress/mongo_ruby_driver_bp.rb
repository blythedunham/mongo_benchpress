
module MongoBenchpress
  class MongoRubyDriverBp< MongoBenchpress::Base
    self.benchmarks = {
      :insert => Proc.new { |coll, object, i|
        object['x'] = i
        coll.insert(object)
      },
      :index_setup => Proc.new { |coll, object|
        coll.create_index('x')
      },
      :insert_batch => Proc.new { |coll, object, i|
        object['x'] = i
        coll.insert([object] * MongoRubyDriverBp.default_options[:batch_size])
      },
      :find_one => Proc.new { |coll, x, i|
        coll.find_one('x' => x)
      },
      :find => Proc.new { |coll, x, i|
        coll.find('x' => x).each {}
      }
    }
  end
end
