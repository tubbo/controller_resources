class TestController
  Params = Struct.new :parameters

  def self.expose(name, options = {})
    define_method name do
      if name == :post
        Post.all.first
      else
        Post.all
      end
    end
  end

  def self.permit(*params)
  end

  def self.decent_configuration(&block)
  end

  def self.helper_method(*args)
  end

  def request
    Params.new parameters: {}
  end

  def params
    {}
  end
end

