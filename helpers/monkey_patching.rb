class Array
  def trim
    self.delete_if { |e| e.empty? }
  end
end

class Hash
  def trim
    self.delete_if { |k, v| v.empty? }
  end
end

