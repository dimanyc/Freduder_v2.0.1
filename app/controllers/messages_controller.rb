class MessagesController < ApplicationController

	# Create
	def new
		@message = Message.new
	end

	def create
		@message = Message.new(message_params)

		if  @message.save
			$client.update(@message.body)
			current_user.messages << @message
			flash[:notice] = "Message Sent"

		else
			flash[:alert] = "Problem sending your message"
		end

		redirect_to user_path(current_user)
	end





	# Read
	def index 
		@messages = Message.all
	end

	def show
		
	end


	# Update
	def analyze # crawls through new tweets with current_user.filters 
		@messages = Message.all

		@messages.each do |message|
			current_user.filters.each do |filter|
			
				if 	filter.evaluate_message(message)
						filter.messages << message
						flash[:notice] = 'Found messages that are mathing your tags' 
				else
					respond_to do |format|
						format.html { flash[:notice] = 'No new messages are matching any of your tags' }
						format.json { render json: @message.errors, status: :unprocessable_entity }
					end # respond_to
				end # filter.evaluate_message
			end # current_user.filters.each do |filter|
		end	# @messages.each 

		redirect_to user_path(current_user)

	end # def analyze

	def refresh # loads new data from Twitter
		@messages = Message.refresh_tweets
		
		if @messages
			redirect_to user_path(current_user)	
			flash[:notice] = "Message feed has been updated"
		else
			flash[:alert] = "Problem reloading the message feed"
		end
		
	end			

	# Destroy
	def destroy
		@messages = Message.all
		@messages.destroy_all

		redirect_to user_path(current_user)
	end


	def post_new_tweet
		@message = Message.new(message_params)

		if @message.save
			current_user.messages << @message
			$client.update(@message.body)
			flash[:notice] = "Message has been posted!"
			redirect_to user_path(current_user)
		else
			flash[:alert] = "Problem posting a new Tweet. Try again later"
		end
	end


	# Strong Params 
	private 

	def message_params
		params.require(:message).permit(:body,:author,:hashtags,:author_image_url,:replies,:mentions)
	end



end
