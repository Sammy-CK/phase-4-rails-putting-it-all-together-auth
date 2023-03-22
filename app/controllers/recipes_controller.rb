class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :recipe_params_invalid
    def index
            if session.include? :user_id
            recipes = Recipe.all
            render json: recipes, status: :created
        else
            render json: {errors: ["You are not logged in"]}, status: :unauthorized
        end
    end

    def create
        if session.include? :user_id
            user = User.find(session[:user_id])
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: :created
        else
            render json: {errors: ["You are not logged in"]}, status: :unauthorized  
        end
    end

    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def recipe_params_invalid(exception)
        render json: {errors: [exception.record.errors.full_messages]}, status: :unprocessable_entity
    end

end
