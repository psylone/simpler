# Контроллер по умолчанию: используется для обработки
# запросов по неправильным адресам
class DefaultController < Simpler::Controller
  def resource_not_found
    status 404
  end
end
