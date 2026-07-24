# bootstrap-win

We can set up Windows PC for development with this repository.  
Motivated with dotfiles.

## How to use

Open PowerShell and run `Get-ExecutionPolicy`.  
If it returns `Restricted`, then run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

Now run `install.ps1`.

## After installation

### Configure Git

Open Git Bash.

Run the following commands to configure your global Git user information and signing key:

```shell
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global user.signingkey "YOUR_GPG_KEY_ID"
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

Please refer to this page for information about GPG keys.

https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account
