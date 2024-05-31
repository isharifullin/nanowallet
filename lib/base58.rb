module Base58
  ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".freeze

  module_function

  def encode(hex)
    leading_zero_bytes = leading_zero_bytes(hex)
    ("1"*leading_zero_bytes) + int_to_base58(hex.to_i(16))
  end

  private

  module_function

  def leading_zero_bytes(hex)
    leading_zeros = hex.match(/^([0]+)/)
    leading_zeros ? leading_zeros.size / 2 : 0
  end

  def int_to_base58(int)
    base = ALPHABET.size
    value = ''
    while int > 0
      int, mod = int.divmod(base)
      value = ALPHABET[mod] + value
    end
    value
  end
end