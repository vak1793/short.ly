class LinksController < ApplicationController

  def relay
    link = Link.find_by(short_url: params[:short_url])
    redirect_to link.long_url, status: link.status_code
  end

  def index
    links = Link.all.map { |l| l.slice('short_url', 'long_url') }
    links.each { |l| l['short_url'] = format_short_link(l['short_url']) }
    render json: links
  end

  def create
    link = Link.create!(long_url: params[:url])
    render plain: format_short_link(link.short_url), status: :created
  rescue ActiveRecord::RecordNotSaved => save_error
    render plain: format_short_link(save_error.record.errors.messages[:duplicate].first), status: :ok
  rescue => error
    retries ||= 0

    if retries < 5
      retries += 1
      retry
    else
      raise error
    end
  end

  def show
    link = Link.find_by(short_url: params[:url]).try { |l| l.slice('short_url', 'long_url') } || []
    if link.present?
      link['short_url'] = format_short_link(link['short_url'])
    end
    render json: link
  end

  def destroy
    Link.find_by(short_url: params[:url]).delete
    head :ok
  rescue
    # record does not exist
    head :no_content
  end
end
