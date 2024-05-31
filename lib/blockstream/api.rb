module Blockstream
  class Error < StandardError; end
  class Api
    include HTTParty

    base_uri 'https://blockstream.info/testnet/api'

    ADDREESS_PATH = '/address/%{address}'
    UTXO_PATH = '/address/%{address}/txs'
    TX_RAW_PATH = '/tx/%{tx_id}/raw'
    POST_TX_PATH = '/tx'

    def address(address)
      response = self.class.get(ADDREESS_PATH % {address: address})
      postprocess(response)
    end

    def utxo(address)
      response = self.class.get(UTXO_PATH % {address: address})
      postprocess(response)
    end

    def tx_raw(tx_id)
      response = self.class.get(TX_RAW_PATH % {tx_id: tx_id})
      postprocess(response)
    end

    def create_tx(tx)
      response = self.class.post(POST_TX_PATH, body: tx)
      postprocess(response)
    end

    private

    def postprocess(response)
      raise Blockstream::Error, "Blockstream API error: #{response.parsed_response}" unless response.success?
      response.parsed_response
    end
  end
end