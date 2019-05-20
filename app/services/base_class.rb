class BaseClass
  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def self.attributes
    @attributes
  end

  def attributes
    self.class.attributes
  end

  def my_attrs
    self.my_attributes = {} if self.my_attributes.nil?
    self.attributes.select { |attr| attr != :validation_context }.each do |i|
      self.my_attributes[i] = self.send(i.to_s)
    end
    self.my_attributes.delete(:my_attributes)
    self.my_attributes
  end
end