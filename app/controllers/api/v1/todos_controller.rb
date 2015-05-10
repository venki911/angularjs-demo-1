class API::V1::TodosController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :get_todo, only: [:show, :update, :destroy]

  def index
    @todos = current_user.todos
    respond_with @todos
  end

  def create
    @todo = current_user.todos.new(todo_params)
    if @todo.save
      respond_with @todo, location: nil, status: :created
    else
      respond_with @todo, location: nil, status: :unprocessable_entity
    end
  end

  def show
    respond_with @todo
  rescue ActiveRecord::RecordNotFound
    head :forbidden
  end

  def update
    @todo.update(todo_params)
    respond_with @todo
  rescue ActiveRecord::RecordNotFound
    head :forbidden
  end

  def destroy
    @todo.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    head :forbidden
  end

  private

  def get_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:item, :price, :description)
  end
end