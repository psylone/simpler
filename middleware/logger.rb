class Logger
  def log(status, env)
    req_method = env['REQUEST_METHOD']
    action = env['simpler.action']
    path = env['PATH_INFO']
    controller = env['simpler.controller']
    type = env['Content-Type']
    template ||= env['simpler.template']

    file = File.open('log/app.log', 'w') # - no such file or directory @ rb_sysopen - '...'

    file.write(
      "Request: #{req_method} #{path} Handler: #{controller}##{action} Response: #{status} #{type} #{template}"
      )
  end
end
