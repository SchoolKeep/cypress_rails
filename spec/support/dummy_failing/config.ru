# frozen_string_literal: true

run ->(_env) {
  sleep 0.2
  [
    200,
    { "Content-Type" => "text/html" },
    [
      <<~HTML
        <html>
          <head><title>Dummy app</title></head>
          <body>
            <h1>Hello Dummy!</h1>
          </body>
        </html>
      HTML
    ]
  ]
}
