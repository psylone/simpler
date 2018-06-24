module Simpler
  class Headers

    HEADER = {plain: "text/plain", nil: "text/html"}

    def initialize(env)
      @env = env
    end

    def header
      get_renderer
    end

    def get_renderer
      if @env['simpler.template'].nil?
        return HEADER[:nil]
      else
        @env['simpler.template'].each do |key, value|
          if HEADER.include?(key)
            return HEADER[key]
          end
        end
      end
    end

  end
end
