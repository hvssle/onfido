module Onfido
  class API
    def method_missing(method, *args)
      Onfido::Dinosaur.new.raaaawwwrrrrr
    rescue NameError
      puts "Critical Error: not enough dinosaurs."
    end

    def respond_to_missing?(method, include_private = false)
      Onfido::Dinosaur.new.raaaawwwrrrrr
    rescue NameError
      puts "Critical Error: not enough dinosaurs."
    end
  end
end
