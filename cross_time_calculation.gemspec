# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'cross_time_calculation'
  s.version     = File.read("VERSION").strip
  s.date        = '2013-06-09'
  s.summary     = "Cross Time calculation"
  s.description = s.summary
  s.authors     = ["David Chen"]
  s.email       = 'mvjome@gmail.com'
  s.homepage    = 'http://github.com/mvj3/cross_time_calculation'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = Dir.glob("test/**/*.rb")
  s.require_paths = ["lib"]
end
