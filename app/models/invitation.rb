class Invitation < PgConnection

  before_validation :generate_code

  protected

  def generate_code
    begin
      self.code = CodeGenerator.generate
    end while Invitation.where(code: self.code).exists?
  end
end
