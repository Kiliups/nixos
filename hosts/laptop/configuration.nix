{
  hostName,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../../modules/linux/desktop/niri.nix
    ../../modules/linux/desktop/plasma.nix
  ];

  networking.hostName = hostName;

  services = {
    tailscale.enable = true;

    fprintd.enable = true;
    fwupd.enable = true;

    pipewire.wireplumber = {
      extraScripts."switch-headset-input.lua" = ''
        local cutils = require("common-utils")

        SimpleEventHook {
          name = "device/select-headset-input",
          before = "device/find-best-routes",
          interests = {
            EventInterest {
              Constraint { "event.type", "=", "select-routes" },
              Constraint { "device.name", "=", "alsa_card.pci-0000_c1_00.6" },
            },
          },
          execute = function(event)
            local selected = event:get_data("selected-routes") or Properties()
            for param in event:get_subject():iterate_params("EnumRoute") do
              local route = cutils.parseParam(param, "EnumRoute")
              if route and route.name == "analog-input-headset-mic" and route.available ~= "no" then
                selected["0"] = Json.Object { index = route.index }:to_string()
              end
            end
            event:set_data("selected-routes", selected)
          end,
        }:register()
      '';

      extraConfig."51-switch-headset-input" = {
        "wireplumber.components" = [
          {
            name = "switch-headset-input.lua";
            type = "script/lua";
            provides = "custom.switch-headset-input";
          }
        ];
        "wireplumber.profiles".main."custom.switch-headset-input" = "required";
      };
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = { 
        OLLAMA_IGPU_ENABLE = "1";
        OLLAMA_FLASH_ATTENTION = "true";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_CONTEXT_LENGTH = "32192";
        RADV_PERFTEST = "transfer_queue,mall";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    iw
    mpv
    openssl
    vulkan-tools
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ffmpegthumbs
    kdePackages.filelight
    kdePackages.gwenview
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kio-extras
    kdePackages.okular
  ];
}
