require "../../../spec_helper"

include ContextHelper

describe Lucky::BetterCookies::Adapters::Encrypted do
  describe ".read" do
    it "returns a decrypted CookieJar" do
      a_value = encryptor.encrypt("some cookie value")
      a_value = Base64.strict_encode(a_value)
      b_value = encryptor.encrypt("another cookie value")
      b_value = Base64.strict_encode(b_value)
      request = build_request
      request.headers.add("Cookie", "a=#{a_value};")
      request.headers.add("Cookie", "b=#{b_value};")

      cookies = Lucky::BetterCookies::Adapters::Encrypted.read(from: request)

      cookies.get(:a).should eq("some cookie value")
      cookies.get(:b).should eq("another cookie value")
    end
  end

  describe ".write" do
    it "adds the Set-Cookie response header" do
      response = HTTP::Server::Response.new(IO::Memory.new)
      cookies = Lucky::CookieJar.new
      cookies.set(:a, "a_value")
      
      Lucky::BetterCookies::Adapters::Encrypted.write(
        cookie_jar: cookies,
        to: response
      )

      response_cookies = HTTP::Cookies.from_headers(response.headers)
      encoded = response_cookies.first.value
      decoded = Base64.decode(encoded)
      decrypted = String.new(encryptor.decrypt(decoded))

      response.headers["Set-Cookie"].should contain("a=")
      decrypted.should eq("a_value")
    end
  end
end

private def encryptor
  Lucky::MessageEncryptor.new(Lucky::Server.settings.secret_key_base)
end