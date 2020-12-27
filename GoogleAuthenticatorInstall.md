## Install
```
git clone https://github.com/mgorny/google-authenticator-libpam-hardened
cd google-authenticator-libpam-hardened
# apt install autoconf automake libtool m4 pkg-config
apt install libpam-dev liboath-dev libqrencode-dev
./bootstrap.sh
./configure
make
sudo make install
```

## Set PAM (require both password and OTP)
https://serverfault.com/questions/996717/debian-add-a-new-pam-module-and-require-it-even-if-password-authentication-is-fa

## Set user
`google-authenticator -t -d -f -lwhc@Debian-1 -iAWSL -r3 -R60 -S15 -W -e10 -g8`
- Time-based
- Disable code reuse
- Force rewrite current config if exist
- Label for user whc@Debian-1 on provider AWSL
- Limit for 3 login in 60 seconds
- Refresh code each 15s
- Minimal window for valid codes
- Generate 10 emergency scratch codes
- 8 digits OTP
