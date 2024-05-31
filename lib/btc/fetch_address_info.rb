module BTC
  class FetchAddressInfo
    SATHOSHI_RATE = 0.00000001

    def call(wallet)
      info = Blockstream::Api.new.address(wallet.address)
      balance = info['chain_stats']['funded_txo_sum'] - info['chain_stats']['spent_txo_sum'] - info['mempool_stats']['spent_txo_sum']
      {balance: balance * SATHOSHI_RATE, address: info['address']}
    end
  end
end