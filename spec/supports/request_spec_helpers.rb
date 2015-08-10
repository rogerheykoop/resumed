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

  def env_with_auth(email, password)
    env.merge({
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
    })
  end
end
