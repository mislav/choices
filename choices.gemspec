# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name    = 'choices'
  gem.version = '0.4.0'

  gem.add_dependency 'hashie', '>= 0.4.0'
  gem.add_development_dependency 'minitest', '~> 5.0.6'

  gem.summary = "Easy settings for your app"
  # gem.description = "Longer description."

  gem.authors  = ['Mislav Marohnić']
  gem.email    = 'mislav.marohnic@gmail.com'
  gem.homepage = 'https://github.com/mislav/choices'
  gem.license  = 'MIT'

  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', '*LICENSE*']
  gem.test_files = Dir.glob('test/test_*.rb')
end
