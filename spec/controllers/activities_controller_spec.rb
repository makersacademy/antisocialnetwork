require 'spec_helper'

describe ActivitiesController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => 1
      response.should render_template "show"
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should render_template "index"
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      pending
      post 'create'
      response.should be_success
    end
  end

end
