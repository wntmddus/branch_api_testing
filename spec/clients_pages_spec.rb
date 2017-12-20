require_relative '../lib/http_client'
require_relative '../lib/branch_page'
require "httparty"
require 'rspec_api_test'

RSpec.describe HttpClient do
  include HTTParty
  #Create HttpClient class object
  let(:httpClient) {HttpClient.new}

  describe 'POST /v1/url' do
    it "creates a new link and returns status code 200" do
      response = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual = JSON.parse(response.body)["url"]
      expect(actual).not_to be_blank
      expect(actual).to include("https://wygz.app.link/")
      expect(response.code).to eq(200)
    end

    it "gives 400 status code and message when failed" do
      #invalid branch key
      response = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3Cd", 2, "Marketing Purposes")
      actual = JSON.parse(response.body)
      expect(response.code).to eq(400)
      expect(actual["error"]["message"]).to include("Invalid or missing app id, Branch key, or secret")
    end
  end

  describe 'GET /v1/url with branch url and branch key' do
    it "receives successful response from GET request and returns status code 200" do
      response_post = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual_post = JSON.parse(response_post.body)
      response_get = httpClient.get(url_wrapper(actual_post["url"]), "key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF")
      actual_get = JSON.parse(response_get.body)
      expect(actual_get["data"]).to be_present
      #p actual_get["data"]
      expect(actual_get["type"]).to be_present
      expect(actual_get["campaign"]).to be_present
      expect(actual_get["channel"]).to be_present
      expect(response_get.code).to eq(200)
    end

    it "gives status code 400 upon failed GET request" do
      response_post = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual_post = JSON.parse(response_post.body)
      response_get = httpClient.get(url_wrapper(actual_post["url"]), "key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3Cd")
      actual_get = JSON.parse(response_get.body)
      expect(response_get.code).to eq(400)
    end

  end

  describe 'created URL to be present in https://dashboard.branch.io/liveview using Android User Agent' do
    it "link created with API is visible in dashboard liveview page" do
      response = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual = JSON.parse(response.body)
      driver1 = Webdriver::UserAgent.driver(:browser => :firefox, :agent => :android_phone)
      driver1.get 'https://dashboard.branch.io/login'
      l = BranchPage.new(driver1)
      l.email="wntmddussla@hotmail.com"
      sleep 1
      l.password="Sksskdi1!"
      l.button
      l.nav_sidebar
      driver1.get 'https://dashboard.branch.io/liveview'
      sleep 4
      #compare value in Web application with value achieved from API
      expect(l.tr).to include(actual["url"][8..actual["url"].length-1])
    end
    #Android click incremented by 1 after this test case
    it "performs click action using Android User Agent" do
      response = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual = JSON.parse(response.body)
      driver1 = Webdriver::UserAgent.driver(:browser => :firefox, :agent => :android_phone)
      driver1.get actual["url"]
    end


    it "verifies click action by comparing link ID achieved from Branch API with link ID in Liveview/click page " do
      response_post = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual_post = JSON.parse(response_post.body)
      response_get = httpClient.get(url_wrapper(actual_post["url"]), "key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF")
      actual_get = JSON.parse(response_get.body)
      driver1 = Webdriver::UserAgent.driver(:browser => :firefox, :agent => :android_phone)
      driver1.get 'https://dashboard.branch.io/login'
      l = BranchPage.new(driver1)
      l.email="wntmddussla@hotmail.com"
      sleep 1
      l.password="Sksskdi1!"
      l.button
      l.nav_sidebar
      driver1.get 'https://dashboard.branch.io/liveview/clicks'
      #60 seconds sleep required to verify click
      sleep 4
      expect(l.tr).to include(actual_get["data"]["~id"])
      expect(l.tr).to include("Android")
    end
    it "verifies Android click action in Quick Links > Action Context Menu > View Stats " do
      response_post = httpClient.post("key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF", 2, "Marketing Purposes")
      actual_post = JSON.parse(response_post.body)
      response_get = httpClient.get(url_wrapper(actual_post["url"]), "key_live_ccxRImHuRrZzX6dfsm6TqigayEaDo3CF")
      actual_get = JSON.parse(response_get.body)
      driver1 = Webdriver::UserAgent.driver(:browser => :firefox, :agent => :android_phone)
      driver1.get 'https://dashboard.branch.io/login'
      l = BranchPage.new(driver1)
      l.email="wntmddussla@hotmail.com"
      sleep 1
      l.password="Sksskdi1!"
      l.button
      driver1.get 'https://dashboard.branch.io/link-stats/' + actual_get["data"]["~id"]
      sleep 500
      #if first trial
      #should wait at least 15 mins to retrieve updated number
      expect(l.android_text).to include("1")

    end
  end
  private
  def url_wrapper(url)
    for i in (0..url.length+2)
      if url[i] == ':'
        url = url[0..i-1] + "%3A" + url[i+1..url.length-1]
      end
      if url[i] == '/'
        url = url[0..i-1] + "%2F" + url[i+1..url.length-1]
      end
    end
    url
  end
end
