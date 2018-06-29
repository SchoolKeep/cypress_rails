# frozen_string_literal: true

run ->(env) {
  sleep 0.2
  request = Rack::Request.new(env)
  if request.path == "/foobar"
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
  else
    [
      404,
      { "Content-Type" => "text/html" },
      [""]
    ]
  end
}
