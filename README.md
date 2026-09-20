# bootstrap-win

We can set up Windows PC for development with this repository.  
Motivated with dotfiles.

## How to use

Open PowerShell and run `Get-ExecutionPolicy`.  
If it returns `Restricted`, then run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

Now run `install.ps1`.

## After installation

### Finish WinGet setup

`install.ps1` imports the packages listed in [config/winget_dependencies.json](config/winget_dependencies.json).
This JSON declares packages to install; it cannot run post-install commands or restart your terminal or IDE.
After installation, close and reopen your terminal application and IDE (including WebStorm) so they pick up changes to `PATH`.
For an IDE terminal, restart the IDE itself before opening a new terminal tab.

### Set up Rust and Cargo for Tauri

`install.ps1` installs Rust and Cargo through the `Rustlang.Rustup` package in the WinGet package list.
The following steps are still required after installation:

1. Close and reopen your terminal application and IDE to refresh `PATH`.
2. Select the stable MSVC toolchain and verify the installation in a new PowerShell session:

   ```powershell
   rustup default stable-msvc
   rustc --version
   cargo --version
   ```

Building Tauri apps on Windows also requires Microsoft C++ Build Tools with the **Desktop development with C++** workload
and the WebView2 Runtime. Installing the Build Tools package alone does not ensure the required workload is selected.
See the [Tauri prerequisites](https://tauri.app/start/prerequisites/) for installation instructions.

### Configure Git

Open Git Bash.

Run the following commands to configure your global Git user information and signing key:

```shell
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global user.signingkey "YOUR_GPG_KEY_ID"
git config --global core.autocrlf input
git config --global core.editor vim
git config --global commit.gpgsign true
git config --global gpg.program gpg
git config --global init.defaultbranch main
git config --global tag.gpgsign true
git config --global alias.root "rev-parse --show-toplevel"
```

Please refer to this page for information about GPG keys.

https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account
