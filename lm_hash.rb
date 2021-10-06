require 'digest/sha2'
require 'openssl'
def split7(str)
    str.scan(/.{1.7}/)
end

def gen_keys(str)
    split7(str).map do |str7|
        bits = split7(str7.unpack("B*")[0]).inject('') do |ret, tkn|
            ret += tkn + (tkn.gsub('1','').size % 2).to_s
        end
        [bits].pack("B*")
    end
end

def apply_des(plain,keys)
    des = OpenSSL::Cipher::DES.new
    keys.map do |key|
        des.key = key
        des.encrypt.update(plain)
    end
end

def lm_hash(password)
    lm_magic = "KGS!@\#$%"
    keys = gen_keys(password.upcase[0,13].ljust(14,"\0"))
    apply_des(lm_magic,keys).join
end