class ComediansController < ApplicationController
  def show
    @comedian = Comedian.find(params[:id])
    @posts = @comedian.posts.order(created_at: :desc)
  end
end
