module STARMAN
  class Openssl < Package
    homepage 'https://openssl.org/'
    url 'https://www.openssl.org/source/openssl-1.0.2h.tar.gz'
    sha256 '1d4007e53aad94a5b2002fe045ee7bb0b3d98f1a47f8b2bc851dcd1c74332919'
    version '1.0.2h'

    depends_on :zlib

    def install

    end
  end
end