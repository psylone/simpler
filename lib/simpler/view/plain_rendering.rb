# To change this license header, choose License Headers in Project Properties.
class PlainRendering

  def initialize(env, _template)
    @env = env
  end

  def render(_binding)
    @env['simpler.template'] + "\n"
  end
end
