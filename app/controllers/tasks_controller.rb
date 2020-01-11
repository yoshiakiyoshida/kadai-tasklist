class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :show, :edit]

  def index
      @tasks = Task.where(user: current_user)
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      flash[:success] = 'Task が正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が登録されませんでした'
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    set_task

    if @task.update(task_params)
      flash[:success] = 'Taskは 正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    set_task
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content,:status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end

end
