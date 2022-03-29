class TestsController < Simpler::Controller

  def index
    @time = Time.now

    set_status(404)
    set_custom_headers({ 'Content-Type' => 'text/plain',
                         'X-Custom-Token' => 'Xz2313YuJ' })
  end

  def create

  end

end
