# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name    = 'choices'
  gem.version = '0.2.4'
  gem.date    = Time.now.strftime('%Y-%m-%d')

  gem.add_dependency 'hashie', '>= 0.4.0'
  # gem.add_development_dependency 'rspec', '~> 1.2.9'

  gem.summary = "Easy settings for your app"
  # gem.description = "Longer description."

  gem.authors  = ['Mislav Marohnić']
  gem.email    = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/choices'

  gem.rubyforge_project = nil

  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
  # gem.files &= `git ls-files -z`.split("\0")
end
