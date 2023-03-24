class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: { a: 'a', b: 'b' }
  end

  def show; end
end
