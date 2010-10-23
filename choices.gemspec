# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name    = 'choices'
  gem.version = '0.1.0'
  gem.date    = Date.today.to_s

  gem.add_dependency 'hashie', '>= 0.4.0'
  # gem.add_development_dependency 'rspec', '~> 1.2.9'

  gem.summary = "Easy settings for your app"
  # gem.description = "Longer description."

  gem.authors  = ['Mislav Marohnić']
  gem.email    = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/choices'

  gem.rubyforge_project = nil
  gem.has_rdoc = false

  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
  # gem.files &= `git ls-files -z`.split("\0")
end
