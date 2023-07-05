class EntitiesController < ApplicationController
  def new
    @entity = Entity.new
    @groups = current_user.groups
    @group = current_user.groups.find(params[:group_id])
  end

  def create
    entity = Entity.create(entity_params)
    entity.author = current_user
    group = current_user.groups.find(params[:group_id])

    if entity.save
      entity.groups << Group.find(params[:entity][:group_ids]) if params[:entity][:group_ids].present?

      redirect_to group_path(group)
      flash[:notice] = 'Entity created successfully'
    else
      redirect_to new_entity_path
      flash[:alert] = entity.errors.full_messages.join(', ')
    end
  end

  private

  def entity_params
    params.require(:entity).permit(:name, :amount)
  end
end
