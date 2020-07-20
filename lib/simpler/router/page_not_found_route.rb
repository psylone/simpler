require_relative '../controller/page_not_found_controller'

module Simpler
  class Router
    class PageNotFoundRoute < Route
      def initialize
        @controller = PageNotFoundController
        @action = nil
      end
    end
  end
end
