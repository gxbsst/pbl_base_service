class CodeGenerator
  class << self
    def generate
      valid_chars = Array('2'..'9') + Array('a'..'z').reject {|c| %w(o i l).include?(c)}
      valid_chars.sample(6).join
    end
  end
end
