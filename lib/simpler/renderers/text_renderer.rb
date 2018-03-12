class TextRenderer

  def initialize(env)
    @env = env
  end

  def render(binding)
    "#{@env['simpler.template'][:text]}\n"
  end

end