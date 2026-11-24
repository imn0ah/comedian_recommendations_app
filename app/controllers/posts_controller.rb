class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @comedians = Comedian.joins(:posts)
                         .group("comedians.id")
                         .order(Arel.sql("MAX(posts.created_at) DESC"))
  end

  def new
    @post = Post.new
  end

  def create
    ActiveRecord::Base.transaction do
      @post = current_user.posts.build(post_params)

      comedian = Comedian.find_or_create_by!(name: params[:comedian_name])
      @post.comedian = comedian

      @post.save!
    end

    redirect_to posts_path, notice: "投稿しました"

    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.messages.values.flatten.first
      render :new, status: :unprocessable_entity
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
