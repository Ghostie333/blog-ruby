class Admin::CommentsController < Admin::BaseController
  before_action :set_comment, only: %i[ create destroy ]

# Poprawione create:
def create
  @comment = @post.comments.build(comment_params)
  @comment.user = current_user if user_signed_in?

  if @comment.save
    redirect_to admin_post_path(@post), notice: t("notices.comment_successfully_created")
  else
    redirect_to admin_post_path(@post), alert: t("alerts.comment_fail_to_create")
  end
end

  def destroy
    @comment.destroy!
    redirect_to admin_post_path(@post), alert: "Komentarz usunięty", status: :see_other
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end
end
