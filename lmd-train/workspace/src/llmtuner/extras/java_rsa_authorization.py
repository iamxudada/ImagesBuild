from functools import wraps
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5
import base64
import datetime
from Crypto import Random


# 示例RSA加密函数
def encrypt_with_rsa(public_key, message):
    key = RSA.importKey(public_key)
    cipher = PKCS1_v1_5.new(key)
    return base64.b64encode(cipher.encrypt(message.encode('utf-8')))


def add_auth_headers(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        app_code = "10001"
        current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        plain_string = f"{app_code}_{current_time}"

        rsa_public_key = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyNHpsiI0v41HwWO7DVqQaVUBkjVG86/XhUcS4E8lPZOKPEnd9QQUBImGXWYVXrbVggRp0XBeKVgqAhqZ6FjeaGpbdCCPH/3LbLeG+MOHlQ9BC0qm1HzYoOoEvUPU8+X0vM+rCopfn4xsL5lURRnFW7xwHQSrHCfMxLQRJwNsvswIDAQAB
-----END PUBLIC KEY-----'''

        encrypted_auth = encrypt_with_rsa(rsa_public_key, plain_string).decode()

        # 确保原始函数中可以通过kwargs获取到headers
        if 'headers' not in kwargs:
            kwargs['headers'] = {}
        kwargs['headers'].update({
            'AppCode': app_code,
            'Authorization': encrypted_auth
        })

        return func(*args, **kwargs)

    return wrapper

def encrypt_str(origin_str_list, encrypt_lenth=1024):
    """
    加密函数
    :param origin_str_list: 需要加密的字符串列表
    :param encrypt_lenth:
    :return:
    """
    # 生成RsaKey对象
    random_generator = Random.new().read
    rsa = RSA.generate(encrypt_lenth, random_generator)
    # 通过RsaKey对象生成私钥，字节形式
    pubkey, privkey = rsa.publickey().exportKey(), rsa.exportKey()
    # 生成RSAKey类型的公钥和私钥
    pubkey, privkey = RSA.importKey(pubkey), RSA.importKey(privkey)
    # 生成cipher对象， 用于加解密操作
    cipher = PKCS1_v1_5.new(pubkey)

    # 存放加密字符串的列表
    encrypt_str_list = []

    for origin_str in origin_str_list:
        # 通过cipher.encrypt加密的数据，加密对象的数据类型需要为bytes类型
        encrypt_str_in_rsa = cipher.encrypt(bytes(origin_str.encode('utf-8')))
        # 在将加密后的字符串通过base64编码
        encrypt_str_in_base64 = base64.encodebytes(encrypt_str_in_rsa)

        # 加密后的字符串添加到encrypt_str_list中
        encrypt_str_list.append(encrypt_str_in_base64)

    return encrypt_str_list, privkey


def decrypt_str(encrypt_str_list, privkey):
    """
    解密函数
    :param encrypt_str_list:加密的字符串列表
    :param privkey: 私钥
    :return:
    """
    decrypt_str_list = []
    # 生成chiper对象， 用于加解密操作
    cipher = PKCS1_v1_5.new(privkey)

    for encrypt_str in encrypt_str_list:
        # 通过base64解码
        decrypt_str_in_base64 = base64.decodebytes(encrypt_str)
        # 通过rsa解密decrypt_str_in_base64
        decrypt_str_in_rsa = cipher.decrypt(decrypt_str_in_base64, 0).decode('utf-8')

        # 将解密后的数据添加到decrypt_str_list中
        decrypt_str_list.append(decrypt_str_in_rsa)

    return decrypt_str_list


import secrets


def generate_api_key(length=50):
    # 生成一个安全的随机字符串作为API密钥
    return secrets.token_urlsafe(length)


if __name__ == "__main__":
    api_key = generate_api_key()
    print(f"Generated API key: {api_key}")
