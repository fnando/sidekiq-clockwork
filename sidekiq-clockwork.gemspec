# frozen_string_literal: true

require "./lib/sidekiq/clockwork/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-clockwork"
  spec.version       = Sidekiq::Clockwork::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]

  spec.summary       = "Sidekiq::Clockwork is a simplistic implementation of a job scheduler based on Clockwork, but without having to run a separated process."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/sidekiq-clockwork"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "rake"
end
