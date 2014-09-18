class CartsController < ApplicationController
  def show
    @contributions = cart.contributions
  end

  def update
    add_contribution || delete_contribution
    redirect_to :back
  end

  def destroy
    delete_contribution
    @contributions = cart.contributions
    render :show
  end

  private

  def add_contribution
    if current_user
      contribution = Contribution.create({loan_id: params[:cart][:loan_id], user_id: current_user.id})
    else
      contribution = Contribution.create({loan_id: params[:cart][:loan_id]})
    end
    cart.add_contribution(contribution)
    flash[:success] = "You've added a $#{contribution.amount.to_i/100}.00 contribution to your cart!"
  end

  def delete_contribution
    contribution = Contribution.find(params[:cart][:contribution_id])
    cart.remove_contribution(contribution)
    flash[:success] = "Removed contribution from cart"
  end
end
