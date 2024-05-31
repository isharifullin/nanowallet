module Commands
  class Send
    def run(args)
      recipient_address = args[0]
      amount = args[1].to_i
      fee_per_byte = (args[2] || 25).to_i

      wallet = WalletStorage.load
      return puts "There's no wallet yet." if wallet.nil?

      result = BTC::CreateTransaction.new.call(wallet, recipient_address, amount, fee_per_byte)

      puts result
    end
  end
end