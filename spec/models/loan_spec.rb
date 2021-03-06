require 'rails_helper'

RSpec.describe Loan, type: :model  do

	let(:loan) do
		create(:loan)
	end

	it 'is valid' do
		expect(loan).to be_valid
	end

	it { should validate_presence_of(:title) }

	it { should validate_presence_of(:description) }

	it { should validate_presence_of(:amount)}

	it {should validate_numericality_of(:amount)}

	it { should validate_presence_of(:requested_by)}

	it { should validate_presence_of(:repayments_begin)}

	it { should validate_presence_of(:monthly_payment)}

	it { should validate_numericality_of(:monthly_payment)}

	it 'has an array of categories' do
		expect(loan.categories).to eq([])
	end

	context "state machine" do
		it "begins as a 'request'" do
			assert_equal 'request', loan.aasm_state
		end

		it "can transition through the states, but onnly in order" do
			refute loan.may_start_repay?
			refute loan.may_pay_off?
			assert loan.may_fulfill?
			loan.fulfill
			assert_equal 'fulfilled', loan.aasm_state

			refute loan.may_fulfill?
			refute loan.may_pay_off?
			assert loan.may_start_repay?
			loan.start_repay
			assert_equal 'repayment', loan.aasm_state

			refute loan.may_fulfill?
			refute loan.may_start_repay?
			assert loan.may_pay_off?
			loan.pay_off
			assert_equal 'repaid', loan.aasm_state
		end
	end

	context "contributions" do
		it "knows how much money is needed to fulfill loan" do
			assert 50000, loan.pending
		end

		it "knows its progress" do
			Contribution.create!(user_id: 1, loan_id: 1, amount: 25000)
			assert 50, loan.progress
		end

		it "changes from request to fulfilled when the contributions equal request amount" do
			assert loan.request?
			Contribution.create!(loan_id: 1, amount: 77500, status: "paid")
			assert_equal 0, loan.pending
			assert loan.fulfilled?
		end
	end
end
