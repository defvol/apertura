require 'rake/testtask'

namespace :test do
  desc "Run all tests"
  task :all do
    test_task = Rake::TestTask.new("alltests") do |t|
      t.test_files = Dir.glob(File.join("test", "**", "*_test.rb"))
    end
    task("alltests").execute
  end
end

