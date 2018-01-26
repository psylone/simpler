class PlainRenderer

  def initialize(env)
    @env = env
  end
  
  def render(binding)
    "#{@env['simpler.template'][:plain]}\n"
  end

end