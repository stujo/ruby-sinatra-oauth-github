require 'spec_helper'

describe 'Sessions' do
  let(:blank_session_data) { {} }
  let(:notes_response) { get '/notes', blank_session_data }
  describe 'No Authentication' do
    it 'should redirect to github oauth' do
      expect(notes_response.location).to start_with("https://github.com/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}&redirect_uri=")
    end
  end
  describe 'Auth Callback' do

    context 'with invalid check state' do
      it 'should have error status' do
        get '/auth/callback'
        expect(last_response).not_to be_ok
      end
    end

    context 'with valid check state' do
      before(:each) do
        stub_request(:post, /github.com\/login\/oauth\/access_token/).
            to_return(status: 200, body: auth_token_exchange.to_json, headers: {})
        stub_request(:get, /api.github.com\/user/).
            with(headers: {"Authorization" => "token #{github_auth_token}"}).
            to_return(status: 200, body: user_api_response.to_json, headers: {})
      end
      context 'with valid github exchange' do
        let(:github_auth_token) { 'e72e16c7e42f292c6912e7710c838347ae178b4a' }
        let(:github_username_example) { 'stujo' }
        let(:github_avatar_example) { 'https://github.com/images/error/octocat_happy.gif' }
        let(:user_api_response) {
          {
              'login' => github_username_example,
              'avatar_url' => github_avatar_example
          }
        }
        let(:auth_token_exchange) {
          {
              "access_token" => github_auth_token,
              "scope" => "repo,gist",
              "token_type" => "bearer"
          }
        }

        let(:check_state) { 'some_random_string' }
        context 'with valid check state' do
          it 'should set current github username and redirect to users notes page' do
            get '/auth/callback', {:state => check_state}, "rack.session" => {'github_oauth_check_state' => check_state}
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path).to eq "/user/#{github_username_example}/notes"
            expect(last_response.body).to have_tag('img', :with => { src: github_avatar_example })
          end
        end

        context 'with invalid check state (resist hijack attempt)' do
          it 'should fail' do
            get '/auth/callback', {:state => check_state}, "rack.session" => {'github_oauth_check_state' => 'other_string'}
            expect(last_response).not_to be_ok
          end
        end

      end

    end
  end
end