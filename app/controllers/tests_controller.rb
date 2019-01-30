class TestsController < Simpler::Controller

  def index
    @time = Time.now
 #   render 'tests/' content_type: 'text/plain', status: 500
    render plain: "Plain text response", content_type: 'text/plain', status: 204
  #  list
  end

  def list

   # render plain: "Plain text response", content_type: 'text/plain', status: 500
     #render :text => "Explosion!", :status => 500
     # render text: 'Hello', content_type: 'text/plain'
  end

  def create

  end

end
