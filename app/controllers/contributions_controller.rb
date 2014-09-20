class ContributionsController < ApplicationController
  def index
    @contributions = current_user.contributions
  end

  def show
    @contribution = current_user.contributions.find(params[:id])
  end

  def update
    @contribution = current_user.contributions.find(params[:contribution][:id])
    @contribution.update(amount: params[:contribution][:amount])
    redirect_to cart_path
  end

  def review
    redirect_to login_path if current_user.nil?
    @contributions = cart.contributions
  end

  def checkout
    @contributions = cart.contributions
    @contributions.each_with_index do |contribution, i|
      amount = params[:amounts][i].to_i * 100
      loan = contribution.loan
      if amount <= loan.pending
        contribution.update={amount: amount, user_id: current_user.id, status: 'paid'}
      end
    end
    session[:cart] = nil
    redirect_to root_path
  end

  def destroy
    current_user.loans.find(params[:id]).destroy
  end
end
