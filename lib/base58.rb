require 'digest/sha2'

module BceExplorer
  # The original code was found here:
  # http://rosettacode.org/wiki/Bitcoin/address_validation#Ruby
  class Base58
    class << self
      ALPHA = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

      def valid?(address)
        sum = address.chars.inject(0) { |a, e| a * 58 + ALPHA.index(e) }.to_s 16
        hex = sum.slice!(0..-9)
        (hex.length...42).each { hex.insert(0, '0') }
        checksum(hex) == sum
      end

      private

      def checksum(hex)
        b = [hex].pack('H*') # unpack hex
        Digest::SHA256.hexdigest(Digest::SHA256.digest(b))[0...8]
      end
    end
  end
end
