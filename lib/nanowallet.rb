require 'openssl'
require 'bitcoin'
require 'httparty'

require_relative './base58.rb'
require_relative './wallet_storage.rb'
require_relative './btc/key.rb'
require_relative './btc/wallet.rb'
require_relative './btc/tx.rb'
require_relative './btc/create_transaction.rb'
require_relative './btc/fetch_address_info.rb'
require_relative './blockstream/api.rb'
require_relative './commands/generate.rb'
require_relative './commands/show.rb'
require_relative './commands/send.rb'

Bitcoin.network = :testnet3