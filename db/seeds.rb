  require_relative './seed/borrower_seeds'
require_relative './seed/loan_seeds'
require_relative './seed/category_seeds'
require_relative './seed/contribution_seeds'

# CATEGORIES
@categories.each do |category|
  Category.create(category)
end

# USERS
@lenders.each do |user|
  User.create(user)
end

@admins.each do |user|
  User.create(user)
end

# BORROWERS and LOANS
@borrowers.each do |user|
    user_ = User.create(user).first
    user_.loans.create(@loans.sample) if user_
end

# PICTURES
# @loans.each_with_index do |loan, i|
#   loan_params = loan[0]
#   loan_params[:image] = File.open("#{$RAILS_ROOT}public/assets/images/seed/loan_#{i + 1}.jpg")
#   Loan.create!(loan_params)
# end


# CONTRIBUTIONS
100.times do Contribution.create(user_id: rand(21..30), loan_id: rand(10), status: "paid")
end
