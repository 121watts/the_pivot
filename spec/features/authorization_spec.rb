require 'rails_helper'

describe 'Authorization', type: :feature do
  context 'As a guest' do
    it 'cannot view a page requiring authorization' do
      visit borrower_path
      expect(current_path).to eq login_path
      expect(page).to have_content 'Register'
    end
  end

  context 'As a borrower' do
    it 'can view a page requiring authorization' do
      register_as_borrower
      login_as_borrower
      visit borrower_path
      expect(current_path).to eq borrower_path
    end
  end
end
