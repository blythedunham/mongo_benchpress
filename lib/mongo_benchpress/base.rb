#!/usr/bin/env ruby
#
# Note: Ruby 1.9 is faster than 1.8, as expected.
# This is copied from mongo benchmarks standard_benchmark

#$LOAD_PATH[0,0] = File.join(File.dirname(__FILE__), '..', 'lib')

require 'mongo'
require 'active_support'

module MongoBenchpress
  class Base
    attr_reader :connection, :db, :options, :results

    class_inheritable_hash :default_options
    self.default_options = {
      :host => 'localhost', 
      :port => Mongo::Connection::DEFAULT_PORT,
      :database => "benchpress",
      :connection_options => {},
      :benchmark_method => :simple_timed_benchmark,
      :trials => 2, 
      :per_trial => 5000,
      :batch_size => 100,
      :small_data => {},
      :medium_data => {
        'integer' => 5,
        'number' => 5.05,
        'boolean' => false,
        'array' => ['test', 'benchmark']
      },
      :large_data => {
        'base_url' => 'http://www.example.com/test-me',
        'total_word_count' => 6743,
        'access_time' => Time.now,
        'meta_tags' => {
          'description' => 'i am a long description string',
          'author' => 'Holly Man',
          'dynamically_created_meta_tag' => 'who know\n what'
        },
        'page_structure' => {
          'counted_tags' => 3450,
          'no_of_js_attached' => 10,
          'no_of_images' => 6
        },
        'harvested_words' => ['10gen','web','open','source','application','paas',
                              'platform-as-a-service','technology','helps',
                              'developers','focus','building','mongodb','mongo'] * 20
      }
    }

    class_inheritable_hash :benchmarks
    self.benchmarks = {}

    def report(str, t = "N/A")
      @results ||= ActiveSupport::OrderedHash.new
      @results[ str ] = t.is_a?( String ) ? t : (options[:per_trial] / t).to_i
      self.class.pretty_print( str, @results[ str ] ) if options[:verbose]
    end

    def pretty_print_results
      self.class.pretty_print_all( self )
    end

    def invoke_named_method( method, *args )
      case method
        when Proc then proc.call( *args )
        when Symbol, String then self.send( method, *args )
        else raise "Unknown method #{method}"
      end
    end
    
    def orm_classname; nil; end

    def benchmark( opts = {} )
  
      benchmark_options = opts.reverse_merge(
        :collection => db.collection( opts[:collection_name] ),
        :classname => ((orm_classname + opts[:collection_name] .classify).constantize if orm_classname),
        :times => options[:per_trial],
        :db => self.db
      )

      test_result = 'N/A'

      if benchmark_options[:method]
        invoke_named_method( options[:setup], benchmark_options ) if options[:setup]
        test_result = invoke_named_method( self.options[:benchmark_method], benchmark_options )
      end
      
      invoke_named_method(options[:result], benchmark_options, test_result) if options[:result]
      report(benchmark_options[:name], test_result)
 
    end

    def simple_timed_benchmark( benchmark_options = {})
      collection = benchmark_options[:classname]||benchmark_options[:collection]
      t0 = Time.new
      benchmark_options[:times].times { |i| benchmark_options[:method].call(collection, benchmark_options[:data], i) }
      time = Time.new.to_f - t0.to_f
    end

    def connect(connection_options = {})
      puts "HOST: #{options[:host]} on port: #{options[:port]}" if options[:verbose]
      @connection = Mongo::Connection.new(
        options[:host], 
        options[:port], 
        options[:connection_options] || {}
      )

      self.connection.drop_database( options[:database] )
      @db = connection.db(  options[:database] )

    end

    def run( args = {} )
      benchmarks = self.benchmarks.merge( args.delete(:benchmarks) || {} )
      @options = self.default_options.merge( args || {} )
      
      connect

      benchmark(:name => 'insert (small, no index)',  :method => benchmarks[:insert], :collection_name => 'small_none', :data => options[:small_data])
      benchmark(:name => 'insert (medium, no index)', :method => benchmarks[:insert], :collection_name => 'medium_none', :data => options[:medium_data])
      benchmark(:name => 'insert (large, no index)',  :method => benchmarks[:insert], :collection_name => 'large_none', :data => options[:large_data])

      benchmark(:name => 'insert (small, indexed)',  :method => benchmarks[:insert], :collection_name => 'small_index', :data => options[:small_data], :setup => options[:index_setup])
      benchmark(:name => 'insert (medium, indexed)', :method => benchmarks[:insert], :collection_name => 'medium_index', :data => options[:medium_data], :setup => options[:index_setup])
      benchmark(:name => 'insert (large, indexed)',  :method => benchmarks[:insert], :collection_name => 'large_index', :data => options[:large_data], :setup => options[:index_setup])

      benchmark(:name => 'batch insert (small, no index)', :method => benchmarks[:insert_batch], :times => options[:per_trial]/options[:batch_size], :collection_name => 'small_bulk', :data => options[:small_data])
      benchmark(:name => 'batch insert (medium, no index)', :method => benchmarks[:insert_batch], :times => options[:per_trial]/options[:batch_size], :collection_name => 'medium_bulk', :data => options[:medium_data])
      benchmark(:name => 'batch insert (large, no index)', :method => benchmarks[:insert_batch], :times => options[:per_trial]/options[:batch_size], :collection_name => 'large_bulk', :data => options[:large_data])

      benchmark(:name => 'find_one (small, no index)', :method => benchmarks[:find_one], :collection_name => 'small_none', :data => options[:per_trial] / 2)
      benchmark(:name => 'find_one (medium, no index)', :method => benchmarks[:find_one], :collection_name => 'medium_none', :data => options[:per_trial] / 2)
      benchmark(:name => 'find_one (large, no index)', :method => benchmarks[:find_one], :collection_name => 'large_none', :data => options[:per_trial] / 2)

      benchmark(:name => 'find_one (small, indexed)', :method => benchmarks[:find_one], :collection_name => 'small_index', :data => options[:per_trial] / 2)
      benchmark(:name => 'find_one (medium, indexed)', :method => benchmarks[:find_one], :collection_name => 'medium_index', :data => options[:per_trial] / 2)
      benchmark(:name => 'find_one (large, indexed)', :method => benchmarks[:find_one], :collection_name => 'large_index', :data => options[:per_trial] / 2)

      benchmark(:name => 'find (small, no index)', :method => benchmarks[:find], :collection_name => 'small_none', :data => options[:per_trial] / 2)
      benchmark(:name => 'find (medium, no index)', :method => benchmarks[:find], :collection_name => 'medium_none', :data => options[:per_trial] / 2)
      benchmark(:name => 'find (large, no index)', :method => benchmarks[:find], :collection_name => 'large_none', :data => options[:per_trial] / 2)

      benchmark(:name => 'find (small, indexed)', :method => benchmarks[:find], :collection_name => 'small_index', :data => options[:per_trial] / 2)
      benchmark(:name => 'find (medium, indexed)', :method => benchmarks[:find], :collection_name => 'medium_index', :data => options[:per_trial] / 2)
      benchmark(:name => 'find (large, indexed)', :method => benchmarks[:find], :collection_name => 'large_index', :data => options[:per_trial] / 2)

      benchmark(:name => 'find range (small, indexed)', :method => benchmarks[:find], :collection_name => 'small_index',
                :data => {"$gt" => options[:per_trial] / 2, "$lt" => options[:per_trial] / 2 + options[:batch_size]})
      benchmark(:name => 'find range (medium, indexed)', :method => benchmarks[:find], :collection_name => 'medium_index',
                :data => {"$gt" => options[:per_trial] / 2, "$lt" => options[:per_trial] / 2 + options[:batch_size]})
      benchmark(:name => 'find range (large, indexed)', :method => benchmarks[:find], :collection_name => 'large_index',
                :data => {"$gt" => options[:per_trial] / 2, "$lt" => options[:per_trial] / 2 + options[:batch_size]})
            
      results
    end

    class << self 
      def run( options )
        new.run( options )
      end

      def pretty_print(str, t = "N/A", seperator='.')
        printf("%s%s\n", str.ljust(60, seperator), t )
      end
  
      def run_test_by_name( name, options ={} )
        require "mongo_benchpress/#{name.to_s.underscore}_bp"
        "MongoBenchpress::#{name.to_s.classify}Bp".constantize.run( options )
      rescue LoadError => e
        puts "FAILED TO LOAD TESTS for #{name}. #{e.to_s}" if options[:verbose]
      end

      def run_suite( *names )
        options = names.last.is_a?( Hash ) ? names.pop : {}
        results = names.inject([]) do |results, name|
          results << run_test_by_name( name, options )
          results
        end
        results << { :header => names }
        pretty_print_all( *results )
      end

      def pretty_print_all( *tests )
        options = tests.last.is_a?( Hash ) ? tests.pop : {}
        
        case options[:header]
          when String, Symbol then printf( options[:header])
          when Array then pretty_print('', options[:header].collect{|x| x.to_s.titleize.ljust(20)}.join(''), ' ') if options[:header]
        end

        tests.first.each do |test_name, test|
          all_results = tests.inject([]) { |all_results, test| all_results << test[ test_name ].to_s.ljust(20); all_results }
          pretty_print( test_name, all_results )
        end
      end
    end

  end
end


