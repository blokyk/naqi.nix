{ ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "pro.courvoisier+acme@gmail.com";
  };
}