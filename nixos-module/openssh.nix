{...}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
    };
  };
}
