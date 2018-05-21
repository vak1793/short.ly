class LinksController < ApplicationController

  def relay
    link = Link.find_by(short_url: params[:short_url])
    redirect_to link.long_url, status: link.status_code
  end

  def index
    links = Link.all.map { |l| l.slice('short_url', 'long_url') }
    render json: links
  end

  def create
    link = Link.create!(long_url: params[:url])
    render plain: link.short_url, status: :created
  rescue => error
    render plain: error.record.errors.messages[:duplicate].first, status: :ok
  end

  def show
    link = Link.find_by(short_url: params[:url]).try { |l| l.slice('short_url', 'long_url') } || []
    render json: link
  end

  # def update
  #   link = Link.find_by(short_url: params[:url]).try { |l| l.slice('short_url', 'long_url') } || []
  #   render json: link
  # end

  def destroy
    Link.find_by(short_url: params[:url]).delete
    head :ok
  rescue
    # record does not exist
    head :no_content
  end
end
