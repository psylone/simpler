class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: "#{@time} This is text from Plain"
  end

  def create

  end

end
