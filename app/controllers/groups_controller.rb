class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  after_action :log_activity, only: %i[create update destroy]

  # GET /groups or /groups.json
  def index
    if turbo_frame_request?
      # Zapytanie przyszło z widgetu na stronie głównej -> ładujemy TYLKO grupy użytkownika
      @groups = current_user.groups
    else
      # Klasyczne wejście na stronę /groups -> ładujemy WSZYSTKIE grupy z bazy
      @groups = Group.all
    end
  end

  # GET /groups/1 or /groups/1.json
  def show
    @group = Group.find(params[:id])

    if @group.nil?
      redirect_back fallback_location: root_path, alert: "Grupa nie istnieje"
    end

    @group_posts = @group.posts
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)
    @group.owner = current_user

    # Dodanie właściciela jako użytkownika
    @group.users << current_user

    respond_to do |format|
      if !@group.name.empty? && @group.save
        redirect_to @group, notice: "Pomyślnie utworzono grupę"
      else
        render :new, alert: "Błąd tworzenia grupy"
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        redirect_to @group, notice: "Group was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      redirect_to groups_path, notice: "Group was successfully deleted.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params.expect(:id))
    end

    # Zezwolenie tylko na podane argumenty
    def group_params
      params.require(:group).permit(:name, :group_picture)
    end
end
