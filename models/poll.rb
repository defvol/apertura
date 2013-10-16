class Poll
  attr_accessor :options

  def initialize(number_of_options=2)
    self.options = []
    self.options << pick(number_of_options)
    self.options.flatten!
  end

  # Temporary pseudo-random implementation
  # Planning to use the Mersenne Twister later
  # Passing 0 number of samples will deliver all found elements
  def pick(number_of_samples, parent_uid=nil)
    _options = []
    if parent_uid.nil?
      _options = Option.where(:parent_uid.exists => false).limit(number_of_samples).all
      raise 'Could not find poll options in database' if _options.empty?
    else
      _options = Option.where(:parent_uid => parent_uid).limit(number_of_samples).all
    end

    number_of_samples > 0 ? _options.sample(number_of_samples) : _options
  end
end

