module EventLogger
  module ClassMethods
  end

  def self.append_features(base)
    base.class_eval do
    end

    super

    base.class_eval do
      after_save :trace_create
      after_update :trace_update
      extend ClassMethods
    end
  end

  private

  def trim_keys(hash, *keys)
    keys.each do |key|
      hash.delete(key)
    end
  end

  def trace_create(record)
    if log?
      attrs = record.attributes.dup
      trim_keys(attrs,"created_at","updated_at")
      log "#{self.class.to_s}.create(#{attrs.inspect})"
    end
  end

  def trace_update(record)
    if log?
      attrs = record.attributes.dup
      obj_id = attrs["id"]
      trim_keys(attrs,"created_at","updated_at","id")
      log "#{self.class.to_s}.find_by_id(#{obj_id}).update_attributes(#{attrs.inspect})"
    end
  end

  def log(message="")
    TimestampedBufferedFileLogger.new(EVENT_LOG).log(message)
  end

  def log?
    false unless defined?(EVENT_LOG)

    if @logging_on
      false
    else
      @logging_on = true
    end
  end
end
