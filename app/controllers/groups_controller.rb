class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy join left]
  before_action :authenticate_user!, only: %i[new create edit update destroy join left]
  after_action :log_activity, only: %i[create update destroy join left]

  # GET /groups or /groups.json
  def index
    if turbo_frame_request?
      # Zapytanie przyszło z widgetu na stronie głównej to ładujemy tylko grupy użytkownika
      @groups = current_user.groups
    else
      # Wejście na stronę /groups to ładujemy wszystkie grupy
      @groups = Group.all
    end
  end

  # GET /groups/1 or /groups/1.json
  def show
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
        format.html { redirect_to group_path(@group), notice: "Pomyślnie utworzono grupę", status: :see_other, allow_other_host: true }
      else
        render :new, alert: "Błąd tworzenia grupy"
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_path(@group), notice: "Group was successfully updated.", status: :see_other }
      else
        render :edit, status: :unprocessable_content
      end
    end
  end


  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to groups_path, notice: "Group was successfully deleted.", status: :see_other }
    end
  end

  # Funkcja do dołączenia do grupy
  def join
    # Sprawdzamy, czy użytkownik już tam nie należy
    unless @group.users.include?(current_user)
      @group.users << current_user
      flash[:notice] = "Dołączyłeś do grupy!"
    else
      flash[:alert] = "Już jesteś członkiem tej grupy."
    end

    redirect_to group_path(@group), notice: "Group was successfully updated.", status: :see_other
  end

  # Funkcja do wyjścia z grupy
  def left
    # Sprawdzamy, czy użytkownik już tam nie należy
    if @group.users.include?(current_user)
      @group.users.delete(current_user)
      flash[:notice] = "Opuściłeś grupę"
    else
      flash[:alert] = "Nie jesteś członkiem tej grupy."
    end

    redirect_to groups_path, notice: "Pomyślnie opuszczono grupę", status: :see_other
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
