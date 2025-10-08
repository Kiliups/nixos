1. Install Homemanager

   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
   sudo nix-channel --update

2. Install Zen via flatpak
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   flatpak install flathub app.zen_browser.zen
4. Configure nextcloud client
5. Thunderbird config
6. Syncthing config
   syncthing
   systemctl --user enable syncthing.service
   systemctl --user start syncthing.service
