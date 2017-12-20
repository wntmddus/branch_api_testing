require "httparty"
require 'rspec_api_test'
require "json"
require 'logger'

class HttpClient
  include HTTParty

  #default type set to 0
  #set type=1 for one time use link
  #set type=2 for Marketing URL
  def initialize
  end

  def post(branch_key, type=0, marketing_title="")
    self.class.post(base_api_endpoint_post,
    :body => { :branch_key => branch_key,
               :campaign => "QATesting",
               :channel => "Automation",
               :type => type,
               :data => { :name => "Seung Yeon Joo",
                          :email => "wntmddussla@hotmail.com",
                          :user_id => "12346",
                          :$deeplink_path => "article/jan/123",
                          :$desktop_url => "https://branch.io",
                          :$marketing_title => marketing_title } }.to_json,
                              :headers => { "Content-Type" => "application/json" } )
  end

  def get(branch_url, branch_key)
    self.class.get(base_api_endpoint_get(branch_url, branch_key))
  end
  private
  def base_api_endpoint_post
    "https://api.branch.io/v1/url/"
  end
  def base_api_endpoint_get(branch_url, branch_key)
    "https://api.branch.io/v1/url?url=#{branch_url}&branch_key=#{branch_key}"
  end
end
