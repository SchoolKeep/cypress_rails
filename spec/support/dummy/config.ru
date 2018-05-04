# frozen_string_literal: true

run ->(_env) {
  sleep 0.2
  [
    200,
    { "Content-Type" => "text/html" },
    ["OK"]
  ]
}
