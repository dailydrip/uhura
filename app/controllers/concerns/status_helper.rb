module StatusHelper
  def is_error?(data)
    if data.respond_to?(:error) && !data.error.blank? || data.respond_to?(:errors) && !data.errors.blank?
      true
    else
      false
    end
  end

  def render_response(data)
    # Can process either raw data or a ReturnVo object
    if data.is_a?(ReturnVo)
      log_error(data.error) if is_error?(data)
      render json: data, status: data.status
    else
      # Wrap in a ReturnVo
      if is_error?(data)
        log_error(data.error)
        render json: return_error(data.error), status: unprocessable_entity
      else
        render json: return_success(data)
      end
    end
  end

  def render_error_msg(msg)
    log_error(msg)
    render json: return_error(message: msg), status: unprocessable_entity
  end

  def render_success_msg(msg)
    render json: return_success(message: msg)
  end
end