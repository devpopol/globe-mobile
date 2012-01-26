require 'rubygems'
Gem::Specification.new do |s|
  s.name     = "globe-mobile"
  s.version  = "0.0.3"
  s.author   = "Greg Moreno"
  s.email    = "greg.moreno@gmail.com"
  s.homepage = "http://www.globelabs.com.ph"
  s.summary  = "A wrapper for sending SMS/MSS using Globe Telecoms API."
  s.description = s.summary
  s.files = Dir.glob("{lib,test}/**/*")
  
  s.require_path = "lib"

  if RUBY_VERSION =~ /1.9/
    s.add_dependency "soap4r-ruby1.9", "~> 2.0.3"
  else
    s.add_dependency "soap4r"
  end
  s.add_dependency "nokogiri"
end
