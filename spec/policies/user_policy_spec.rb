require 'rails_helper'

describe UserPolicy do 

	subject { UserPolicy }

	#let (:current_user) { FactoryGirl.build_stubbed :user }
	#let (:other_user) { FactoryGirl.build_stubbed :user }
	#let (:admin) { FactoryGirl.build_stubbed :user, :admin }

	let (:admin_user) {create(:user, role: "admin")}
	let (:power_user) {create(:user, role: "puser")}
	let (:normal_user) {create(:user, role: "nuser")}
	let (:other_user) {create(:user, role: "nuser")}

	permissions :index? do

		it 'denies access if not an admin or power user' do 
			expect(UserPolicy).not_to permit(normal_user)
		end

		it 'allows access if is an admin' do 
			expect(UserPolicy).to permit(admin_user)
		end

	end

	permissions :show? do

		it 'prevents other users from seeing profile' do 
			expect(UserPolicy).not_to permit(normal_user, other_user)
		end

		it 'allows owner to see profile' do 
			expect(subject).to permit(admin_user, admin_user)
		end

		it 'allows admin to see profile' do 
			expect(subject).to permit(admin_user, other_user)
		end		

		it 'allows admin to see profile' do 
			expect(subject).to permit(admin_user, normal_user)
		end	

		it 'allows admin to see profile' do 
			expect(subject).to permit(admin_user, power_user)
		end	

	end

end

