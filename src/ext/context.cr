class HTTP::Server
  class Context
    property params : Hash(String, String) = {} of String => String

    def redirect(url, status_code = 302)
      @response.headers.add "Location", url
      @response.status_code = status_code
    end
  end
end
