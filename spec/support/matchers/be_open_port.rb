# frozen_string_literal: true

RSpec::Matchers.define :be_open_port do
  match do |actual|
    !system("lsof -i:#{actual}", out: "/dev/null")
  end
end
