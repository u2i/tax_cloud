class Hash #:nodoc: all
  # Downcase the keys. Use this because <tt>TaxCloud::Address.verify</tt> requires downcased keys
  def downcase_keys
    reduce({}) do |h, (k, v)|
      h[k.downcase] = v
      h
    end
  end
end
