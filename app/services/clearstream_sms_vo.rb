class ClearstreamSmsVo
  Invalid = Class.new(StandardError)
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :template_id, :from, :to, :dynamic_template_data, :personalizations
  validates :template_id, :from, presence: true

  def initialize(*args)
    super
  end

  def from=(from)
    @from = {
        "email":from
    }
  end
  def from
    @from
  end

  def to=(to)
    @personalizations.to = to
  end
  def to
    @personalizations.to
  end

  def dynamic_template_data=(dynamic_template_data)
    @personalizations.dynamic_template_data = dynamic_template_data
  end
  def dynamic_template_data
    @personalizations.dynamic_template_data
  end

  def get
    if !valid?
      raise Invalid, errors.full_messages
    end
    {template_id: @template_id, from: @from, "personalizations": [@personalizations.get]}
  end


  class Personalizations
    Invalid = Class.new(StandardError)
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :to, :dynamic_template_data
    validates :to, :dynamic_template_data, presence: true

    def ActiveModel::initialize(*args)
      super
      validate!
    end

    # sgv_personalizations.dynamic_template_data" = {
    #     "header":"test header",
    #     "text":"blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
    #     "c2a_button": "Sign me up!"
    # }

    def to=(to)
      @to = [
          {
              "email":to
          }
      ]
    end

    def get
      if !valid?
        raise Invalid, errors.full_messages
      end
      {to: @to, dynamic_template_data: @dynamic_template_data}
    end

    def as_json(*)
      super.except("validation_context", "errors")
    end
  end

end
