require 'httparty'
require 'json'


class Kele
  include HTTParty

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    if response.code == 404
      puts "Sorry, Invalid email or password"
    end
    @auth_token = response['auth_token']
  end

  def get_me
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_roadmap(roadmap_id)
    response = self.class.get(api_url("roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    @roadmap_data = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(api_url("checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
    @checkpoint_data = JSON.parse(response.body)
  end

  def get_messages(page_num=nil)
    if page_num == nil
      response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(api_url("message_threads?page=#{page_num}"), headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body)
  end

  def create_message(user_id, recipient_id, token, subject, message)
    response = self.class.post(api_url("messages"),
      body: {
        "user_id": user_id,
        "recipient_id": recipient_id,
        "token": token,
        "subject": subject,
        "stripped_text": message
        },
        headers: {"authorization" => @auth_token})
    puts response
  end

end
