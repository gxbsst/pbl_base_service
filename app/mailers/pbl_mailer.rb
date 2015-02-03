class PblMailer < ActionMailer::Base
  def run(options = {})

    mail(from: options[:from],
         to: options[:to],
         body: options[:body],
         content_type: "text/html",
         subject: options[:subject])
  end
end
