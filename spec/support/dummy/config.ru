# frozen_string_literal: true

run ->(_env) {
  sleep 1
  [
    200,
    { "Content-Type" => "text/html" },
    ["OK"]
  ]
}
