class HomeController < ApplicationController
	before_action :authenticate_user!

	def index
		@stock_statics = AccountStatic.where(user_id: current_user.id)

        @stock_account_histories = Journal.stock_account.where(user_id: current_user.id).includes(:user, :details)
        @stock_split_histories = Journal.stock_split.where(user_id: current_user.id).includes(:user, :details)
        @stock_ransom_histories = Journal.stock_ransom.where(user_id: current_user.id).includes(:user, :details)
	end
end