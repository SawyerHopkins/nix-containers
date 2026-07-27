{
  description = "Containerized Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = ["aarch64-linux"];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          sshdConfig = pkgs.writeText "sshd_config" ''
            Port 22
            PermitRootLogin prohibit-password
            PubkeyAuthentication yes
            PasswordAuthentication no
            KbdInteractiveAuthentication no
            UsePAM no
            HostKey /etc/ssh/ssh_host_ed25519_key
            AuthorizedKeysFile .ssh/authorized_keys
            PidFile /run/sshd.pid
            Subsystem sftp internal-sftp
          '';

          loginProfile = pkgs.writeText "bash_profile" ''
            export PATH="/root/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
            export NIX_CONFIG="experimental-features = nix-command flakes"

            # prevent shell loop
            if [[ $- == *i* && -z ''${IN_NIX_DEVELOP:-} && -f /workspace/flake.nix ]]; then
              export IN_NIX_DEVELOP=1
              cd /workspace && exec nix develop
            fi

            # shellcheck source=/dev/null
            [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
          '';

          start-sshd = pkgs.writeShellApplication {
            name = "start-sshd";
            runtimeInputs = [ pkgs.openssh pkgs.coreutils pkgs.gnused ];
            text = ''
              # sshd needs a dedicated privilege-separation user; the base image has none.
              if ! grep -q '^sshd:' /etc/passwd; then
                echo 'sshd:x:74:74:SSH privsep:/var/empty:/bin/false' >> /etc/passwd
                echo 'sshd:x:74:' >> /etc/group
                echo 'sshd:!:1::::::' >> /etc/shadow
              fi

              # sshd's privilege-separation and runtime directories.
              mkdir -p /var/empty && chmod 0755 /var/empty
              mkdir -p /run

              # one time host key setup
              # @TDO make this stable across multiple containers
              mkdir -p /etc/ssh
              if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
                ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
              fi

              # Install root's authorized key from $SSH_PUBKEY or a mounted file.
              mkdir -p /root/.ssh
              chmod 700 /root/.ssh
              if [ -n "''${SSH_PUBKEY:-}" ]; then
                echo "$SSH_PUBKEY" > /root/.ssh/authorized_keys
              elif [ -e /authorized_keys ]; then
                cp /authorized_keys /root/.ssh/authorized_keys
              fi
              if [ -e /root/.ssh/authorized_keys ]; then
                chmod 600 /root/.ssh/authorized_keys
              else
                echo "WARNING: no SSH key installed. Pass -e SSH_PUBKEY=... or mount /authorized_keys." >&2
              fi

              # interactive SSH logins drop into the flake dev shell.
              ln -sf ${loginProfile} /root/.bash_profile

              # Unlock root
              sed -i 's/^root:[^:]*:/root::/' /etc/shadow

              # Become the container's main process.
              exec /root/.nix-profile/bin/sshd -D -e -f ${sshdConfig}
            '';
          };
        in
        {
          inherit start-sshd;
          default = start-sshd;
        }
      );
    };
}