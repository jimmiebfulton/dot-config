[user]
    email = jimmie@ybor.ai
    signingkey = /Users/jimmie/.ssh/id_ed25519_work.pub

[core]
    sshCommand = "ssh -i ~/.ssh/id_ed25519_work"

[gpg]
    format = ssh

[gpg "ssh"]
    allowedSignersFile = ~/.config/git/allowed_signers

[commit]
    gpgsign = true
