class AuthorsController < ApplicationController
  before_action :set_author, only: [:destroy]

  def new
    @user = current_user
    @author = Author.new
  end

  def create
    @author = Author.new(author_params.merge({user_id: current_user.id}))

    respond_to do |format|
      if @author.save
        format.html { redirect_to current_user, notice: 'Author was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Author was successfully destroyed.' }
    end
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name, :email)
    end
end
