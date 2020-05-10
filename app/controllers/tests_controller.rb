class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def plain_text
    render plain: "Plain text response"
  end

  def hyper_text
    render html: "<html><h3>HTML response</h3></html>"
    status 202
  end
end
