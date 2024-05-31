module BTC
  class Wallet
    NETWORK_BYTE = "6f"

    attr_reader :key, :address

    def initialize(key)
      @key = key
      @address = address_from_key(key.public_key)
    end

    private

    def address_from_key(public_key)
      bytes = [public_key].pack("H*")
      hex = Digest::RMD160.hexdigest(Digest::SHA256.digest(bytes))
      hex = NETWORK_BYTE + hex
      bytes = [hex].pack("H*")
      checksum =  Digest::SHA256.hexdigest(Digest::SHA256.digest(bytes))[0...8]
      Base58.encode(hex + checksum)
    end
  end
end