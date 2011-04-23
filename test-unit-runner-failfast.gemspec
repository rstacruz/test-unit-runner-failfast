Gem::Specification.new do |s|
  s.name = "test-unit-runner-failfast"
  s.version = "0.0.1"
  s.summary = %{A Test::Unit runner that shows errors first.}
  s.description = %Q{Test::Unit::Runner::Failfast allows you to see your Test::Unit errors more intuitively.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/test-unit-runner-failfast"
  s.files = ["lib/test/unit/runner/failfast.rb", "README.md"]

  s.add_dependency "test-unit", ">= 2.2"
end
