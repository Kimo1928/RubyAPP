module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: [:show, :update, :destroy]
      before_action :authorized
      before_action :authorize_user!, only: [:update, :destroy]

      def index
        @posts = Post.all
        render json: @posts
      end

      def show
        render json: @post
      end

      def create
        @post = Post.new(post_params.except(:tags))
        @post.author = current_user
      
        if params[:post][:tags].is_a?(Array)
          clean_tags = params[:post][:tags].reject(&:blank?)
          @post.tags = clean_tags.join(',')
        else
          @post.tags = ''
        end
      
        if @post.save
          DeletePostJob.set(wait: 24.hours).perform_later(@post.id)
      
          render json: { message: "Post created", post: @post }, status: :created
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end
      

      def update
        if params[:post][:tags].is_a?(Array)
          @post.tags = params[:post][:tags].reject(&:blank?).join(',')
        elsif params[:post][:tags].is_a?(String) && params[:post][:tags].strip == ""
          @post.tags = ""
        end
      
        if @post.update(post_params.except(:tags))
          render json: { message: "Post updated", post: @post }
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy
        render json: { message: "Post deleted" }
      end

      private

      def set_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end

      def authorize_user!
        unless @post.author == current_user
          render json: { error: "You are not authorized to perform this action" }, status: :forbidden
        end
      end
    end
  end
end
