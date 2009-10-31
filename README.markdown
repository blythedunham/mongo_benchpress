MongoBenchPress
===============
Run the mongodb benchmarks for:
* [mongoruby driver (mongo)](http://github.com/mongodb/mongo-ruby-driver)
* ORM [MongoMapper](http://github.com/jnunemaker/mongomapper)
* ORM [MongoRecord (aka mongo_active_record)](http://github.com/mongodb/mongo-activerecord-ruby)


Install
-------
    script/plugin install git://github.com/blythedunham/mongo_benchpress

Rake Tasks
---------
    rake benchpress:mongo_ruby_driver
    rake benchpress:mongo_mapper
    rake benchpress:mongo_record
    rake benchpress:all

Standalone
----------
    RAILS_ROOT/vendor/plugins/mongo_benchpress/mongo_ruby_driver


Copyright (c) 2009 Blythe Dunham, snowgiraffe, and grapes released under the MIT license
