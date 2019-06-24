class TestsController < Simpler::Controller
  def index
    @time = Time.now
    return unless params['inline']

    status 201

    case params['inline']
    when 'erb'
      render erb: '<b>time from erb <%= @time %></b>'
    when 'plain'
      headers['Content-Type'] = 'text/plain'
      render plain: @time
    end
  end

  def create; end

  def show; end
end
