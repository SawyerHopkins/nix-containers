FROM nixos/nix

ENV NIX_CONFIG="experimental-features = nix-command flakes"

RUN nix-channel --update

WORKDIR /workspace
COPY flake.nix flake.nix

ENTRYPOINT ["nix", "develop", "--command", "bash"]
