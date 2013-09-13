ENV['RACK_ENV'] ||= "development"

require 'rake/testtask'
require './landa'

namespace :test do

  desc "Run all tests"
  task :all do
    test_task = Rake::TestTask.new("all") do |t|
      t.test_files = Dir.glob(File.join("test", "**", "*_test.rb"))
    end
    task("all").execute
  end

  desc "Run base tests"
  task :base do
    test_task = Rake::TestTask.new("base") do |t|
      t.test_files = Dir.glob(File.join("test", "base_test.rb"))
    end
    task("base").execute
  end

  desc "Run acceptance tests"
  task :acceptance do
    test_task = Rake::TestTask.new("acceptance") do |t|
      t.test_files = Dir.glob(File.join("test", "acceptance_test.rb"))
    end
    task("acceptance").execute
  end

  desc "Run API tests"
  task :api do
    test_task = Rake::TestTask.new("api") do |t|
      t.test_files = Dir.glob(File.join("test", "api_test.rb"))
    end
    task("api").execute
  end

end

namespace :db do

  desc "Clear database"
  task :clear do
    raise "Do not run this in production!" if ENV['RACK_ENV'] == "production"

    puts "Clearing database at #{MongoMapper.database.name}"
    puts "#{User.delete_all.count} objects deleted"
  end

  desc "Seed database"
  task :seed, :count do |t, args|
    raise "Do not run this in production!" if ENV['RACK_ENV'] == "production"

    # Number of seeds defaults to 1
    count = args[:count].to_i || 1

    puts "Seeding #{count} records to database at #{MongoMapper.database.name}"

    (0...count).each do |e|
      user = User.new(email: random_email, data_requests: [random_request])
      user.save(:safe => true)
      # Fake registration date
      user.created_at = random_date
      user.save(:safe => true)
    end

    puts "#{count} objects saved"
  end

end

# Some helpers

def random_email
  "seed-#{('a'..'z').to_a.shuffle[0,8].join}@foo.bar"
end

def random_request
  { category: ["Salud", "Seguridad", "Medio ambiente"].sample }
end

# A day during the last month
def random_date
  Time.now() + rand(-15..15) * (60 * 60 * 24)
end

