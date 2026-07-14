class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    filter = params[:query]

    if filter.present?
      # Dołączamy usera ORAZ tabelę z treścią bogatą Action Text
      @posts = Post.left_joins(:user, :rich_text_content)
                  .where(
                    "posts.title ILIKE :q OR
                      users.email ILIKE :q OR
                      action_text_rich_texts.body ILIKE :q",
                    q: "%#{filter}%"
                  )
                  .order(created_at: :desc)
    else
      @posts = Post.limit(10).order(created_at: :desc)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_post_path(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @post.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: "#{t('posts.post_successfully_updated')}"
    else
      render :edit, alert: "#{t('posts.post_fail_to_update')}"
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    redirect_to admin_posts_path, notice: "#{t('posts.post_successfully_destroyed')}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
