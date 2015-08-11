module RequestSpecHelpers

  def get_with_auth(path, email, password)
    get path, {}, env_with_auth(email, password)
  end

  def delete_with_auth(path, email, password)
    delete path, {}, env_with_auth(email, password)
  end

  def post_with_auth(path, params, email, password)
    post path, params, env_with_auth(email, password)
  end

  def patch_with_auth(path, params, email, password)
    patch path, params, env_with_auth(email, password)
  end

  def env
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  def it_should_have_the_same_user_id_as(object)
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(object.id)
  end

  def it_should_have_the_same_email_as(email)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql(email)
  end

  def it_should_disallow_this
    expect(JSON.parse(last_response.body)).to eql({ "errors" => "Error: You are not allowed to do this.", "status" =>403  })
  end


  def env_with_auth(email, password)
    env.merge({
                'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
    })
  end
end
