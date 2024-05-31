module BTC
  class Key
    attr_reader :private_key, :public_key

    def initialize(private_key: nil)
      if private_key
        @private_key = private_key
        @public_key = generate_public_key(private_key)
      end
    end

    def generate!
      @private_key, @public_key = generate_keys
    end

    private

    def generate_keys
      key = OpenSSL::PKey::EC.new("secp256k1")
      key.generate_key
      [key.private_key.to_s(16).downcase, key.public_key.to_octet_string(:compressed).unpack("H*")[0]]
    end

    def generate_public_key(private_key)
      private_key_bn = OpenSSL::BN.new(private_key, 16)
      group = OpenSSL::PKey::EC::Group.new('secp256k1')
      public_key = group.generator.mul(private_key_bn)
      public_key.to_octet_string(:compressed).unpack("H*")[0]
    end
  end
end