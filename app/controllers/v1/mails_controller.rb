class V1::MailsController < ApplicationController

  # params:
  # { from: 'gxbsst@gmail.com', to: 'gxbsst@gmail.com', subject: 'subject', body: 'body'}
  def create
    PblMailer.run(params[:mail]).deliver
    head :created
  rescue
    head :unprocessable_entity
  end
end
