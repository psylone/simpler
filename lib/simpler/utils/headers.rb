class Headers
  def initialize(response)
    @response = response
  end

  def []=(key, value)
    @response.headers.[]=(key, value)
  end
end
