module IncludeLoggers
  extend self

  def for(*args)
    return unless args.present?
    return unless defined?(EVENT_LOG)

    args.each do |klass|
      # puts "trying: #{klass.inspect}"
      klass.class_eval do
        include EventLogger
      end
    end
  end
end
