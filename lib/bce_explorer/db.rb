require 'mongo'
require_relative './models/address'
require_relative './models/info'
require_relative './models/transaction'
require_relative './models/wallet'

module BceExplorer
  # db storage
  class DB
    include Mongo

    attr_reader :address, :info, :transaction, :wallet

    def initialize(options = {})
      host = options[:host] || 'localhost'
      port = options[:port] || 27_017
      dbname = options[:dbname] || 'blockexplorer'

      MongoClient.new(host, port).db(dbname).tap do |dbh|
        @address = Address.new dbh
        @info = Info.new dbh
        @transaction = Transaction.new dbh
        @wallet = Wallet.new dbh
      end
    end
  end
end
