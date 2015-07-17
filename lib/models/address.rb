module BceExplorer
  # Address balance storage
  class Address < Base
    def initialize(dbh, db_gate)
      super dbh
      # dependencies below needed in #known_address_info only
      @wallet = db_gate.wallet
      @tx_address = db_gate.tx_address
      @tx_list = db_gate.tx_list
    end

    # get address balance
    def [](address)
      result = find_one address
      balance = result['balance'] unless result.nil?
      # this code for situations when address document exists
      # but has no 'balance' property yet, because wallet upserted it
      balance || 0.0
    end

    # set balance
    def []=(address, balance)
      query = { _id: address }
      update = { '$set' => { balance: balance } }
      upsert query, update
    end

    def top(count)
      query = {}
      order = { balance: :desc }
      find_order_limit(query, order, count)
    end

    def info(address)
      if known_address? address
        known_address(address)
      else
        { 'address' => address, 'balance' => 0.0,
          'wallet_id' => '', 'wallet_knowns' => 0,
          'tx_count' => 0, 'tx' => nil }
      end
    end

    private

    def known_address?(address)
      !find_one(address).nil?
    end

    def known_address(address)
      wallet_id = @wallet.id address

      {
        'address' => address,
        'balance' => self[address],
        'wallet_id' => wallet_id,
        'wallet_size' => @wallet.count(wallet_id),
        'tx_count' => @tx_address.count(address),
        'tx' => @tx_address[address].map { |txid| @tx_list[txid] }.compact
      }
    end
  end
end