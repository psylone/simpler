class AppLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
  end
end
