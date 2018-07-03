class BooksController < Simpler::Controller

  def index
     set_headers("text/html")
     set_status("200")
  end

  def show
    set_headers("text/html")
    set_status("200")
  end

  def new
  end

  def create
    set_status("201")
  end

end
