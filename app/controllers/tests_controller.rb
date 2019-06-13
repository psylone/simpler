class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render html: "<pre><b>avada cadavra</b></pre>"
  end

  def create

  end

end
