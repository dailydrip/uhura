# frozen_string_literal: true

module StatusHelper
  def error?(data)
    if data.respond_to?(:error) && !data.error.blank? || data.respond_to?(:errors) && !data.errors.blank?
      true
    else
      false
    end
  end

  def render_response(data)
    # Can process either raw data or a ReturnVo object
    if data.is_a?(ReturnVo)
      log_error(data.error) if error?(data)
      render json: data, status: data.status
    elsif error?(data)
      log_error(data.error)
      render json: return_error(data.error), status: unprocessable_entity
    else
      render json: return_success(data)
    end
  end

  def render_error_msg(msg, status = unprocessable_entity)
    log_error(msg)
    render json: return_error(message: msg), status: status
  end

  def render_success_msg(msg, options={})
    data = {message: msg}.merge(options) # Return message.id in options
    render json: return_success(data)
  end
end
