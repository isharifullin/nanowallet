module Commands
  class Generate
    def run(_args)
      key = BTC::Key.new
      key.generate!
      WalletStorage.save(key.private_key)
      puts "New address successfully generated."
    end
  end
end