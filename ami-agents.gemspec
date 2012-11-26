Gem::Specification.new do |s|
  s.name = "ami-agents"
  s.version = "0.0.1"
  s.summary = "ami-agents"
  s.authors = [ "Jeremy Deininger" ]
  s.email = [ "jeremydeininger@gmail.com" ]
  s.files = [ "lib/ami-agents/version.rb",
              "lib/ami-agents.rb" ]
  s.add_dependency("celluloid", ">=0.12.3")
  s.add_dependency("dcell", ">=0.12.0.pre")
  s.add_dependency("aws-sdk", ">=1.7.1")
  s.add_dependency("trollop", ">=2.0")
  s.add_dependency("highline")
  s.add_dependency("pry")
end
