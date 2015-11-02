# coding: utf-8

Gem::Specification.new do |s|
  s.name         = 'womb'
  s.version      = '0.0.2'
  s.author       = 'Max White'
  s.email        = 'mushishi78@gmail.com'
  s.homepage     = 'https://github.com/mushishi78/womb'
  s.summary      = 'A Ruby library for birthing objects'
  s.license      = 'MIT'
  s.files        = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
