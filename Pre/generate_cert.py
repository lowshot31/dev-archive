from OpenSSL import crypto, SSL
from socket import gethostname
from pprint import pprint
from time import gmtime, mktime
from os.path import exists, join

CERT_FILE = "cert.pem"
KEY_FILE = "key.pem"

def create_self_signed_cert():
    """
    If cert.pem and key.pem don't exist, create them.
    """
    
    if exists(CERT_FILE) and exists(KEY_FILE):
        print(f"Certificate {CERT_FILE} and Key {KEY_FILE} already exist.")
        return

    # create a key pair
    k = crypto.PKey()
    k.generate_key(crypto.TYPE_RSA, 4096)

    # create a self-signed cert
    cert = crypto.X509()
    cert.get_subject().C = "KR"
    cert.get_subject().ST = "Seoul"
    cert.get_subject().L = "Seoul"
    cert.get_subject().O = "Pre Dairy"
    cert.get_subject().OU = "Dev"
    cert.get_subject().CN = "localhost"
    cert.set_serial_number(1000)
    cert.gmtime_adj_notBefore(0)
    cert.gmtime_adj_notAfter(10*365*24*60*60)
    cert.set_issuer(cert.get_subject())
    cert.set_pubkey(k)
    cert.sign(k, 'sha256')

    open(CERT_FILE, "wt").write(
        crypto.dump_certificate(crypto.FILETYPE_PEM, cert).decode("utf-8")
    )
    open(KEY_FILE, "wt").write(
        crypto.dump_privatekey(crypto.FILETYPE_PEM, k).decode("utf-8")
    )
    print(f"Generated {CERT_FILE} and {KEY_FILE}")

if __name__ == "__main__":
    try:
        create_self_signed_cert()
    except ImportError:
        print("pyopenssl is not installed. Installing it now...")
        import subprocess
        subprocess.check_call(["pip", "install", "pyopenssl"])
        create_self_signed_cert()
