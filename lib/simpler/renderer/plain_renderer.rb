# frozen_string_literal: true

class PlainRenderer
  def initialize(env)
    @env = env
  end

  def render(_binding)
    "#{@env['simpler.template'][:plain]}\n"
  end
end
