require 'singleton'

module Simpler
  class Application

    include Singleton

    def call(env)
      [
        200,
        { 'Content-Type' => 'text/plain' },
        ["Simpler application at work!\n"]
      ]
    end

  end
end
