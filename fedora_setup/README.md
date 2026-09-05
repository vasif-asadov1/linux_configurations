# Update

After succesfully setting up Fedora, first thing you should do is update the entire system to ensureyou have the latest packages and security patches: 

```bash
sudo dnf upgrade --refresh
```

Reboot your system after the update is complete. Don't forget that step because it will affect the kernel and all system components. 


# Nvidia Drivers 

The next thing is installing the appropriate Nvidia drivers for GPU model. I have a GeForce GTX 1050, so the last driver version that supports my GPU is 580.xx. So, I should install the 580.xx drivers. Check your GPU model and find the last driver version that supports it. You can check the supported driver versions on Nvidia's official website.

**Enable the repository for Nvidia drivers:**

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

**Install the Nvidia drivers:**

```bash
sudo dnf install akmod-nvidia-580xx xorg-x11-drv-nvidia-580xx-cuda
```

After the installation is complete, wait for 5 minutes and then run the following command to make sure the Nvidia kernel module is loaded:

```bash
modinfo -F version nvidia
```

Then reboot your system to apply the changes. After rebooting, you can check if the Nvidia drivers are working properly by running:

```bash
nvidia-smi
```

If the command returns information about your GPU, then the drivers are installed and working correctly. If you encounter any issues, you may need to check the logs or consult the Fedora forums for troubleshooting tips.

In the next updates of Fedora, to prevent the system to update your Nvidia drivers as well,  add the following line to your `/etc/dnf/dnf.conf` file:

```bash
echo "exclude=akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda kmod-nvidia" | sudo tee -a /etc/dnf/dnf.conf
```

After this, your Nvidia drivers will not be updated automatically with the system updates, so the GPU driver installation is completed.


# Fish terminal and Starship prompt

For beautiful terminal experience, I recommend installing the Fish shell and Starship prompt. Because, the default Bash shell is not as user-friendly and customizable as Fish. Fish terminal allows you to have syntax highlighting, autosuggestions, and a more intuitive command-line experience. Starship prompt is a minimal, blazing-fast, and infinitely customizable prompt for any shell.

**Install Fish shell and Starship prompt:**

```bash
sudo dnf install fish starship
```

**Set Fish as the default shell:**

```bash
chsh -s /usr/bin/fish
```

After this, log out and log back in to start using Fish as your default shell.

**Configure Starship prompt:**

```bash
mkdir -p ~/.config/fish
echo 'starship init fish | source' >> ~/.config/fish/config.fish
```

**Reload the Fish shell:**

```bash
source ~/.config/fish/config.fish
```


After succesfull installation, you will be able to enjoy a beautiful terminal experience with Fish shell and Starship prompt. You can further customize the Starship prompt by editing the `~/.config/starship.toml` file. For more information on customization options, you can refer to the [Starship documentation](https://starship.rs/config/).

By default, fish terminal greets you with a welcome message. If you want to disable it, you can run the following command:

```bash
set -U fish_greeting ""
```

If you want to add fastfetch to your terminal, you can install it using the following command:

```bash
sudo dnf install fastfetch
```

Then, add the following line to your `~/.config/fish/config.fish` file to display system information when you open a new terminal:

```bash
echo "fastfetch" >> ~/.config/fish/config.fish
```

After this, every time you open a new terminal, fastfetch will display system information along with the Starship prompt. You can customize the output of fastfetch by editing the `~/.config/fastfetch/config.conf` file.



# Github and SSH Key

To securely connect to GitHub and manage your repositories, you should set up an SSH key. This allows you to authenticate with GitHub without needing to enter your username and password every time.

**Install git and xclip:**

```bash
sudo dnf install git xclip
```


**Generate a new SSH key:**

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

**Start the SSH agent for Fish shell:**

```bash
eval (ssh-agent -c)
```

**Add your SSH private key to the SSH agent:**

```bash
ssh-add ~/.ssh/id_ed25519
```

**Copy the SSH public key to your clipboard:**

```bash
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

**Add the SSH key to your GitHub account:**
1. Go to your GitHub account settings.
2. Navigate to "SSH and GPG keys".
3. Click "New SSH key", give it a title, and paste the copied public key into the "Key" field.
4. Click "Add SSH key" to save it.
5. You may be prompted to enter your GitHub password to confirm the addition of the key.
6. Test the SSH connection to GitHub:

```bash
ssh -T git@github.com
```

If it shows a message like "Hi username! You've successfully authenticated, but GitHub does not provide shell access.", then your SSH key is set up correctly and you can now use it to interact with your GitHub repositories securely.


You should also configure your Git username and email for commits:

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```


# Flatpak 

**Flatpak** is a software utility for software deployment, application virtualization, and package management. It allows you to install and run applications in a sandboxed environment, which can help improve security and compatibility across different Linux distributions.

**Install Flatpak and KDE backends:**

```bash
sudo dnf install flatpak plasma-discover-flatpak
```

If you are using GNOME, you can install the GNOME backends instead:         

```bash
sudo dnf install flatpak gnome-software-plugin-flatpak
```

**Add the Flathub repository to your system:**

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**Update Fish shell to support Flatpak:**

```bash
fish_add_path -a /var/lib/flatpak/exports/bin ~/.local/share/flatpak/exports/bin
```

Restart your system and done.
















