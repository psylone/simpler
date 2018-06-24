module Simpler
  class Status

    STATUS = {GET: 200, POST: 201}

    def initialize(env)
      @env = env
    end

    def status
      correct_get.to_s
    end

    def correct_get

      STATUS.each do |item|
        if item.include?(:"#{@env["REQUEST_METHOD"]}")
        return STATUS[:"#{@env["REQUEST_METHOD"]}"]
      else
        404
      end

      end
    end

  end

end
