require 'actionmailer'

class ActionMailer::Base
  class << self
    def smtp_settings_by_from_address
      @smtp_settings_by_from_address ||= {}
    end
  end
  
  def deliver_with_intelligent_smtp!(mail = @mail)
    if ActionMailer::Base.smtp_settings_by_from_address[mail.from.first.downcase]
      # Save the default email settings.
      original_smtp_settings = self.class.smtp_settings
      begin
        # Apply the from address specific settings.
        self.class.smtp_settings = ActionMailer::Base.smtp_settings_by_from_address[mail.from.first.downcase]
        # Send the message.
        deliver_without_intelligent_smtp! mail
      ensure  
        # Return smtp_settings to original settings.
        self.class.smtp_settings = original_smtp_settings
      end
    else  
      deliver_without_intelligent_smtp! mail
    end 
  end
  alias_method :deliver_without_intelligent_smtp!, :deliver!
  alias_method :deliver!, :deliver_with_intelligent_smtp!
end