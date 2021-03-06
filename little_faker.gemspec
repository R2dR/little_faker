Gem::Specification.new do |s|
  s.name        = 'little_faker'
  s.version     = '0.9.2'
  s.date        = '2013-07-30'
  s.license     = 'MIT'
  s.summary     = "Delegation interface for Faker gem"
  s.description = "Call Faker methods from one namespace, ie. Faker::Lorem.word => Fake.word"
  s.authors     = ["R2dR"]
  s.email       = 'github@r2dr.com'
  s.files       = Dir['lib/**/*.rb', 'LICENSE', 'README.*']
  s.homepage    = 'http://github.com/r2dr/little_faker'
  s.add_dependency('faker', '>= 1.2.0')
  s.requirements << 'faker, v1.2.0 or greater'
  s.required_ruby_version = '>= 1.9'
end
