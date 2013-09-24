class PagesController < ApplicationController

  def home
    @page = Page.home.first!
    render :show
  end

  def show
    @page = Page.published.find(params[:id])

    if bad_slug?(@page)
      redirect_to_good_slug(@page)
      return
    end
  end

  private

  def bad_slug?(page)
    params[:id] != page.to_param
  end

  def redirect_to_good_slug(page)
    redirect_to page_path(page), status: :moved_permanently
  end

end
