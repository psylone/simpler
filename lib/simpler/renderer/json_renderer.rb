require 'json'

class JSONRenderer
  def initialize(env)
    @env = env
  end

  def render(binding)
    "#{@env['simpler.template'][:json].to_json}\n"
  end
end
