class MyMailer < Devise::Mailer
 
  def confirmation_instructions(record, token, opts={})
    options = {
      :subject => "Job Hunt Email Confirmation",
      :email => record.email,
      :global_merge_vars => [
        {
          name: "confirmation_link",
          content: "#{domain}/users/confirmation?confirmation_token=#{token}"
        },
        {
          name: "email",
          content: record.email
        }
      ],
      :template => "confirmation"
    }
    mandrill_send options  
  end
  
  def reset_password_instructions(record, token, opts={})
    options = {
      :subject => "Password Reset",
      :email => record.email,
      :global_merge_vars => [
        {
          name: "password_reset_link",
          content: "#{domain}/users/password/edit?reset_password_token=#{token}"
        },
        {
          name: "email",
          content: record.email
        }
      ],
      :template => "reset-password"
    }
    mandrill_send options  
  end
  
  def unlock_instructions(record, token, opts={})
    options = {
      :subject => "Job Hunt Account Unlock",
      :email => record.email,
      :global_merge_vars => [
        {
          name: "unlock_link",
          content: "#{domain}/users/unlock?unlock_token=#{token}"
        },
        {
          name: "email",
          content: record.email
        }
      ],
      :template => "confirmation"
    }
    mandrill_send options  
  end

  def domain
    return @domain unless @domain
    if Rails.env == 'production'
      return @domain = 'http://job-hunt.herokuapp.com'
    else
      return @domain = 'http://localhost:3003'
    end
  end
  
  def mandrill_send(opts={})
    message = { 
      :subject=> "#{opts[:subject]}", 
      :from_name=> "job hunt",
      :from_email=>"job-hunt@job-hunt.com",
      :to=>
            [{"name"=>"Some User",
                "email"=>"#{opts[:email]}",
                "type"=>"to"}],
      :global_merge_vars => opts[:global_merge_vars]
      }
    sending = MANDRILL.messages.send_template opts[:template], [], message
    rescue Mandrill::Error => e
      Rails.logger.debug("#{e.class}: #{e.message}")
      raise
  end
  
end