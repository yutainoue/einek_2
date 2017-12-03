module LogOutput
  def log_info(m, e)
    Rails.logger.info { [m, e.message, *e.backtrace].join("\n") }
  end

  def log_warn(m, e)
    Rails.logger.warn { [m, e.message, *e.backtrace].join("\n") }
  end

  def log_error(m, e)
    Rails.logger.error { [m, e.message, *e.backtrace].join("\n") }
  end
end
