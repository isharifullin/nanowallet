module Commands
  class Show

    def run(_args)
      wallet = WalletStorage.load
      return puts "There's no wallet yet." if wallet.nil?

      info = BTC::FetchAddressInfo.new.call(wallet)
      puts "Address: #{info[:address]}"
      puts "Balance: #{info[:balance]} BTC"
    end
  end
end