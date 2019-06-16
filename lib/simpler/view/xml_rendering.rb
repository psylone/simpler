# To change this license header, choose License Headers in Project Properties.
class XMLRendering

  def initialize(env, template)
    @env = env
    @template = template
  end

  def erb_init
    ERB.new(@template)
  end

  def render(binding)
    erb_init.result(binding)
  end
end
