1. Install Homemanager

   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
   sudo nix-channel --update

2. Install Zen via flatpak
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   flatpak install flathub app.zen_browser.zen
3. Configure fprintd
4. Configure onedrive/nextcloud client
   onedrive
   systemctl --user enable onedrive
systemctl --user start onedrive 
5. Thunderbird config
6. Syncthing config
   syncthing
   systemctl --user enable syncthing.service
   systemctl --user start syncthing.service
