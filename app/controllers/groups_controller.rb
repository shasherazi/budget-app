class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def show
    @group = Group.find_by(id: params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.create(group_params)
    group.author = current_user

    if group.save
      redirect_to group_path(group)
      flash[:notice] = 'Group created successfully'
    else
      redirect_to new_group_path
      flash[:alert] = group.errors.full_messages.join(', ')
    end
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
