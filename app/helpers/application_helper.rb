module ApplicationHelper
  def fb_login_and_redirect(url, options = {})
    # Check if we got the update_page method (pre-Rails 3.1)
    if respond_to? 'update_page'
      js = update_page do |page|
        page.redirect_to url
      end
    # Else use plain js
    else
      js = "window.location.href = '#{url}'"
    end
    text = options.delete(:text)
  
    #rails 3 only escapes non-html_safe strings, so get the raw string instead of the SafeBuffer
    content_tag("fb:login-button",text,options.merge(:onlogin=>js.to_str))
  end

  def fb_logout_link(text,url,*args)
    function= "FB.logout(function() {window.location.href = '#{url}';})"
    link_to_function text, function.to_str, *args
  end  
end
