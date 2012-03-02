# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name    = 'scoped-choices'
  gem.version = '0.0.1'
  gem.date    = Time.now.strftime('%Y-%m-%d')

  gem.add_dependency 'hashie', '>= 0.4.0'
  # gem.add_development_dependency 'rspec', '~> 1.2.9'

  gem.summary = "Easy settings for your app"
  gem.description = "Based off Mislav's choices gem allows for scoping your configuration"

  gem.authors  = ['Mislav Marohnić', 'Samer Masry']
  gem.email    = 'samer@onekingslane.com'
  gem.homepage = 'http://github.com/okl/choices'

  gem.rubyforge_project = nil
  gem.has_rdoc = false

  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
  # gem.files &= `git ls-files -z`.split("\0")
end
