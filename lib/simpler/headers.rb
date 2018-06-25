module Simpler
  class Headers

    HEADER = {plain: "text/plain"}
    DEFAULT_HEADER = "text/html"

    def initialize(env)
      @env = env
    end

    def header
      get_renderer
    end

    def get_renderer
      if @env['simpler.template'].nil?
        return DEFAULT_HEADER
      else
        @env['simpler.template'].each_key do |key|
          if HEADER.include?(key)
            return HEADER[key]
          end
        end
      end
    end

  end
end
