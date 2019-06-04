class TestsController < Simpler::Controller
  def index
    @time = Time.now
    return unless params['inline']

    headers['Content-Type'] = 'text/plain'
    status 201
    render erb: '<%= @time %>'
  end

  def create; end

  def show; end
end
