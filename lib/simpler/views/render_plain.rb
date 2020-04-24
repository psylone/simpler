# frozen_string_literal: true

class RenderPlain
  def initialize(env)
    @env = env
  end

  def render(_binding)
    @env['simpler.template.body'].to_s
  end
end
