module Simpler
  class HelpersController < Controller

    def not_found
      render plain: 'Page not found', status: 404, headers: {'Content-Type' => 'text/plain'}
    end

  end
end
