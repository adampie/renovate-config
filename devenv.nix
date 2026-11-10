{ config, pkgs, ... }:
{
  packages = [
    pkgs.renovate
    pkgs.zizmor
  ];

  scripts = {
    validate = {
      description = "Validate the Renovate preset and this repo's self-config";
      exec = ''cd "$DEVENV_ROOT" && renovate-config-validator --strict --no-global default.json5 renovate.json5'';
    };
    audit-workflows = {
      description = "Audit the GitHub Actions workflows for security issues";
      exec = ''cd "$DEVENV_ROOT" && zizmor .github/workflows/'';
    };
  };

  git-hooks.hooks = {
    renovate-validate = {
      enable = true;
      entry = "${config.scripts.validate.scriptPackage}/bin/validate";
      files = "\\.json5$";
      pass_filenames = false;
    };
    zizmor.enable = true;
  };
}
