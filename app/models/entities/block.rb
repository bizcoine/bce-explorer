module BceExplorer
  # Block entity
  module Entities
    Block = Struct.new :hash,
                       :confirmations,
                       :size,
                       :height,
                       :version,
                       :mint,
                       :merkleroot,
                       :prevhash,
                       :nexthash,
                       :time,
                       :difficulty,
                       :flags,
                       :txs do
      def self.create_from(params = {})
        new params['hash'], params['confirmations'], params['size'],
            params['index'], params['version'], params['mint'],
            params['merkleroot'], params['previousblockhash'],
            params['nextblockhash'], params['time'],
            params['difficulty'], params['flags'], params['tx']
      end

      def pos?
        flags.include? 'proof-of-stake'
      end

      def pow?
        flags == 'proof-of-work'
      end
    end
  end
end
