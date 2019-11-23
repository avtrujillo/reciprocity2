class UnsupportedProviderError < StandardError

  def message
    "Unsupported OAuth provider"
  end

end