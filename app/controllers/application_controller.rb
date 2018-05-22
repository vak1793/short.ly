class ApplicationController < ActionController::API
  def format_short_link(url)
    formatted = "#{request.domain}"
    formatted << ":#{request.port}" unless request.port == 80
    formatted << "/#{url}"
    formatted
  end
end
