
module Events
  def self.included(target)
    target.extend(ClassMethods)
  end

  module ClassMethods
    EVENT_NAME_MUST_BE_SYMBOL = "Имя события должно быть символом"

    def event(event_name)
      raise TypeError, EVENT_NAME_MUST_BE_SYMBOL unless event_name.is_a?(Symbol)

      event_var = "@#{event_name}".to_sym

      define_method(event_name) do
        instance_variable_get(event_var) || instance_variable_set(event_var, [])
      end
    end  
  end
  
  def when_fired(event_name, &command)
    raise TypeError, EVENT_NAME_MUST_BE_SYMBOL unless event_name.is_a?(Symbol)
    
    event_subscribers = send(event_name)
    event_subscribers << command unless event_subscribers.include?(command)
  end

  def on(event_name, &command)
    when_fired(event_name, &command)
  end
  
  def fire(event_name, *args)
    raise TypeError, EVENT_NAME_MUST_BE_SYMBOL unless event_name.is_a?(Symbol)

    event_subscribers = send(event_name)
    event_subscribers.each do |subscriber|
      subscriber.call(*args)
    end
  end
  
end
