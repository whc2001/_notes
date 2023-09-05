https://github.com/drduh/YubiKey-Guide

https://occamy.chemistry.jhu.edu/references/pubsoft/YubikeySSH/index.php

https://gist.github.com/johannes-mueller/aced99865328dcf577a2f68f329ffccd

https://medium.com/byteschneiderei/setting-up-pam-ssh-agent-auth-for-sudo-login-7135330eb740

https://superuser.com/a/670071

https://gist.github.com/BoGnY/f9b1be6393234537c3e247f33e74094a

# DO NOT ENABLE **KDF** OR PIN WILL NOT WORK FOR `PAGEANT.EXE` BY PETER KOCH

# DO NOT RUN `gpg-connect-agent /bye` WITH ADMIN OR PUTTY WILL NOT BE ABLE TO CONNECT

# sudo 
apt install libpam-ssh-agent-auth

## visudo 
Defaults env_keep += SSH_AUTH_SOCK

## /etc/pam.d/sudo 
auth sufficient pam_ssh_agent_auth.so file=~/.ssh/authorized_keys
