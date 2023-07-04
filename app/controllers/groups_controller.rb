class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def show; end

  def new
    @group = Group.new
  end

  def create
    group = Group.create(group_params)
    redirect_to group_path(group)
  end

  def edit
    @group = Group.find_by(id: params[:id])
  end

  def update
    group = Group.find_by(id: params[:id])
    group.update(group_params)
    redirect_to group_path(group)
  end

  def destroy
    Group.destroy(params[:id])
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :icon)
  end
end
