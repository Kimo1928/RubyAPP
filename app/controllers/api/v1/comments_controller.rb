class Api::V1::CommentsController < ApplicationController
  before_action :authorized
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_comment_owner!, only: [:update, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = params[:post_id]   
  
    if @comment.save
      render json: { message: 'Comment created successfully', comment: @comment }, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def update
    if @comment.update(comment_params)
      render json: { message: 'Comment updated successfully', comment: @comment }, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    render json: { message: 'Comment deleted successfully' }, status: :ok
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end

  def authorize_comment_owner!
    unless @comment.user == current_user
      render json: { error: "You are not authorized to modify/delete this comment" }, status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
