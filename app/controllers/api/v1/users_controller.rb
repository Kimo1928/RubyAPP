class Api::V1::UsersController < ApplicationController
    def create
      user = User.new(user_params)
      if user.save
        token = encode_token(user_id: user.id)
        render json: { user: user, token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.permit(:name, :email, :password, :image)
    end
  end
  