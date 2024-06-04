module BTC
  class CreateTransaction
    include Bitcoin::Builder

    OUTPUT_BYTESIZE = 34
    INPUT_BYTESIZE = 148
    BASE_BYTESIZE = 10 + OUTPUT_BYTESIZE * 2

    def call(wallet, recipient_address, amount, fee_per_byte)
      transactions = load_transactions(wallet.address)
      transactions = reject_spent_in_unconfirmed(transactions)
      transactions = select_input_transactions(transactions, wallet.address, amount, fee_per_byte)
      return "Insufficient funds." if transactions.nil?

      transaction_hash = build_transaction_hash(wallet, recipient_address, transactions, amount, fee_per_byte)
      blockstrem_api.create_tx(transaction_hash)
    end

    private

    def load_transactions(address)
      blockstrem_api.utxo(address).map { |tx| BTC::Tx.new(tx) }
    end

    def reject_spent_in_unconfirmed(transactions)
      confirmed, unconfirmed = transactions.partition { |tx| tx.confirmed? }
      spent_in_unconfirmed_txids = unconfirmed.map(&:input_txids).flatten
      confirmed.reject { |tx| spent_in_unconfirmed_txids.include?(tx.id) }
    end

    def select_input_transactions(transactions, address, amount, fee_per_byte)
      funded_sum = 0
      result = []
      bytesize = BASE_BYTESIZE
      while funded_sum <= (amount + bytesize * fee_per_byte) && transactions.any? do
        tx = transactions.pop
        bytesize += INPUT_BYTESIZE
        result << tx
        funded_sum += tx.funded_sum(address)
      end
      funded_sum >= (amount + bytesize * fee_per_byte) ? result : nil
    end

    def build_transaction_hash(wallet, recipient_address, input, amount, fee_per_byte)
      key = Bitcoin::Key.new(wallet.key.private_key, wallet.key.public_key)
      available_amount = input.sum { |tx| tx.funded_sum(wallet.address) }
      bytesize = BASE_BYTESIZE + INPUT_BYTESIZE * input.size
      fee = bytesize * fee_per_byte

      tx = build_tx do |t|
        input.each do |tx|
          protocol_tx = Bitcoin::P::Tx.new(tx.binary)
          t.input do |i|
            i.prev_out protocol_tx
            i.prev_out_index tx.output_idx(wallet.address)
            i.signature_key key
          end
        end

        t.output do |o|
          o.value amount
          o.script {|s| s.recipient recipient_address }
        end

        t.output do |o|
          o.value available_amount - amount - fee
          o.script {|s| s.recipient key.addr }
        end
      end

      tx.to_payload.unpack("H*")[0]
    end

    def blockstrem_api
      @blockstrem_api ||= Blockstream::Api.new
    end
  end
end
