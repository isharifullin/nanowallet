module BTC
  class Tx
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def id
      attributes["txid"]
    end

    def binary
      @binary ||= Blockstream::Api.new.tx_raw(id)
    end

    def hex
      binary.unpack('H*')[0]
    end

    def input_txids
      attributes["vin"].map {|vin| vin["txid"] }
    end

    def confirmed?
      attributes["status"]["confirmed"]
    end

    def funded_sum(address)
      attributes["vout"].select do |vout|
        vout["scriptpubkey_address"] == address
      end.sum { |vout| vout["value"] }
    end

    def output_idx(address)
      attributes["vout"].index do |vout|
        vout["scriptpubkey_address"] == address
      end
    end
  end
end