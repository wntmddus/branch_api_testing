Gem::Specification.new do |s|
  s.name          = 'branch_api'
  s.version       = '0.0.1'
  s.date          = '2017-12-17'
  s.summary       = 'Branch API Client'
  s.description   = 'A client for the Branch API'
  s.authors       = ['Seung Yeon Joo']
  s.email         = 'wntmddussla@hotmail.com'
  s.files         = ['lib/clients.rb']
  s.require_paths = ["lib"]
  s.homepage      =
    'http://rubygems.org/gems/branch_project'
  s.license       = 'MIT'
  s.add_runtime_dependency 'httparty', '~> 0.13'
end
