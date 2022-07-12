class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "#{@time} This is text from Plain"
  end

  def create
    set_headers('text/html')
    render plain: "This is text from Plain create"
  end

end
