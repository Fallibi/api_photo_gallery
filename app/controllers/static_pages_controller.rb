class StaticPagesController < ApplicationController
  def home
    # Only proceed if a collection_id is provided and is not just whitespace.
    if params[:collection_id].present? && !params[:collection_id].strip.empty?
      begin
        # Ensure the API key is present.
        api_key = ENV.fetch('PEXELS_API_KEY')
        client = Pexels::Client.new(api_key)

        # First, we .find() the specific collection by its ID.
        collection = client.collections.find(params[:collection_id])
        
        # Then, we call .media on the result.
        @photos = collection.media

      rescue KeyError
        # This catches the error if PEXELS_API_KEY is not set.
        @photos = []
        flash.now[:alert] = "PEXELS_API_KEY is not set. Please check your configuration."
      
      # This will catch other errors, like an invalid collection ID from Pexels.
      rescue StandardError => e
        @photos = []
        flash.now[:alert] = "An error occurred: #{e.message}. The collection ID might be invalid or not found."
      end
    end
  end
end


