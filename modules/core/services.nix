{ ... }:
{
  config = {
    # Basic services
    services.printing.enable = true;
    services.fstrim.enable = true;
    services.pcscd.enable = true;

    # PipeWire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
