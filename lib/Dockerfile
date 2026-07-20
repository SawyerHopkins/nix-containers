FROM nixos/nix

ENV NIX_CONFIG="experimental-features = nix-command flakes"

RUN nix-channel --update

WORKDIR /workspace
COPY flake.* /workspace

RUN nix develop --command true

ENTRYPOINT ["nix", "develop", "--command", "bash"]
