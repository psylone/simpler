module Simpler
  class View
	class HTMLRenderer < View
	  def start(bind_context)
	    render(bind_context)
	  end
	end
  end
end
