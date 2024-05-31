module WalletStorage
  module_function

  def load
    return unless File.exist?(filename)

    private_key = File.read(filename)
    key = BTC::Key.new(private_key: private_key)
    BTC::Wallet.new(key)
  end

  def save(private_key)
    Dir.mkdir(directory_name) unless File.exist?(directory_name)
    File.rename(filename, File.join(directory_name, Time.now.to_i.to_s)) if File.exist?(filename)
    File.write(filename, private_key)
  end

  private

  module_function

  def filename
    File.join(directory_name, 'current')
  end

  def directory_name
    File.expand_path('../keys', __dir__)
  end
end