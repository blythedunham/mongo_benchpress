
MBP_DIR = File.join(File.dirname(__FILE__), '..', 'bin')
BENCH_PRESS_TASKS = %w(mongo_ruby_driver mongo_mapper mongo_record)

def run_benchmark( script_name )
  raise "Specify a SCRIPT param" unless script_name
  
  script_file = File.join( MBP_DIR, script_name )
  raise "#{script_file} is not a valid file." unless File.exist?( script_file )

  commands = []
  commands << "export MONGO_RUBY_DRIVER_HOST=#{ENV['MONGO_RUBY_DRIVER_HOST']}" if ENV['MONGO_RUBY_DRIVER_HOST']
  commands << "export MONGO_RUBY_DRIVER_PORT=#{ENV['MONGO_RUBY_DRIVER_PORT']}" if ENV['MONGO_RUBY_DRIVER_PORT']
  commands << script_file

  full_command = commands.join(' && ')
  puts "Running: #{script_name}"
  puts system( full_command ) unless ENV['DRY_RUN']
end

namespace :benchpress do
  desc 'run mongo_bench_press test SCRIPT. rake benchmark:press SCRIPT=my_script'
  task :press do 
    run_benchmark( ENV['SCRIPT'] )
  end

  BENCH_PRESS_TASKS.each do |mongo_task|
    desc "Run benchmarks for #{mongo_task} MONGO_RUBY_DRIVER_HOST=localhost MONGO_RUBY_DRIVER_PORT=27017"
    task mongo_task do
      run_benchmark( "#{mongo_task}_benchmark" )
    end
  end
  
  task :mongomapper => :mongo_mapper
  task :mongorecord => :mongo_record
  task :mongo => :mongo_ruby_driver

  desc "Run all mongo ORM benchmarks"
  task :all => BENCH_PRESS_TASKS
end
