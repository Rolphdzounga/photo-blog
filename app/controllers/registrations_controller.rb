
class RegistrationsController < Devise::RegistrationsController

def create

	build_resource(sign_up_params)
	#NEW USER TRANSACTION
	resource.class.transaction do

		resource.save

		yield resource if block_given?
		#NEW USER IN DB?
		if resource.persisted?
			#NEW PAYMENT OBJ
			@payment = Payment.new({ email: params["user"]["email"],
			#carte ok si token
			token: params[:payment]["token"], user_id: resource.id })
			#CHECK NEW OBJ....
			flash[:error] = "Please check registration errors" unless @payment.valid?
			#PAYEMENT TRANSACTION....
			begin

				@payment.process_payment

				@payment.save
				#IF ANY ERROR
				rescue Exception => e

				flash[:error] = e.message
				#DESTROY NEW USER
				resource.destroy

				puts 'Payment failed'

				render :new and return

			end
			#IF USER HAS ACTIVATED HIS ACCOUNT
			if resource.active_for_authentication?

				set_flash_message :notice, :signed_up if is_flashing_format?

				sign_up(resource_name, resource)

				respond_with resource, location: after_sign_up_path_for(resource)

			else#IF NOT

				set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?

				expire_data_after_sign_in!

				respond_with resource, location: after_inactive_sign_up_path_for(resource)

			end

		else

			clean_up_passwords resource

			set_minimum_password_length

			respond_with resource

		end

	end

end

protected

	def configure_permitted_parameters

		devise_parameter_sanitizer.for(:sign_up).push(:payment)

	end

end