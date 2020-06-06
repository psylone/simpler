# frozen_string_literal: true

require 'logger'
require_relative 'log_format'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info([LogFormat.new(env, @app).formatter].join(' '))
    @app.call(env)
  end
end
