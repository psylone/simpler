module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @path_regexp = make_path_regexp
      end

      def match?(method, path)
        @method == method && match_path(path)
      end

      def route_info(env)
        path = env['PATH_INFO']
        @route_info ||= begin
          resource = path_fragments(path)[0] || "base"
          id, action = find_id_and_action(path_fragments(path)[1])
          { resource: resource, action: action, id: id }
        end
      end     

      def find_id_and_action(fragment)
        case fragment
        when "new"
          [nil, :new]
        when nil
          action = @request.get? ? :index : :create
          [nil, action]
        else
          [fragment, :show]
        end
      end

      def match_path(path)
        path.match(@path_regexp)
      end      

      def make_path_regexp
        path_parts = @path.split('/')
        path_parts.map! do |part|
          if part[0] == ":"
            part.delete!(':')
            part = "(?<#{part}>\\w+)"
          else
            part  
          end
        end
        str_regexp = path_parts.join("\\/")
        /#{str_regexp}$/
      end

      def path_fragments(path)
        @fragments ||= path.split("/").reject { |s| s.empty? }
      end          

    end
  end
end
