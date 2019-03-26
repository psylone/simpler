# не придумал куда его положить
module Simpler
  class NotfoundController < Controller
    def not_found
      set_status(404)
      render plain: "Not found. Now is #{Time.now}"
    end
  end
end
