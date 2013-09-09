require 'rake/testtask'

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

