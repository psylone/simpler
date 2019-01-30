class TestsController < Simpler::Controller

  def index
    @time = Time.now
    list
 #   render plain: "оОЛОЛо"
    # render plain: "tests/index", status: 202
 #   render 'tests/' content_type: 'text/plain', status: 500

#render plain: "Plain text response", content_type: 'text/plain', status: 204
  #  list
  end

  def list
    render html: "<h1><i>HERE WE GO </i></h1>", status: 202

   # render plain: "Plain text response", content_type: 'text/plain', status: 500
     #render :text => "Explosion!", :status => 500
     # render text: 'Hello', content_type: 'text/plain'
  end

  def create
  end
end
