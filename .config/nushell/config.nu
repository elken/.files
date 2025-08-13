# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge {
    "PATH": {
        from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
        to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.config.show_banner = false

$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt | append (source ~/.config/nushell/nu_scripts/nu-hooks/nu-hooks/direnv/config.nu)
)

if not ("~/.config/nushell/scripts/mise.gen.nu" | path exists) {
    ~/code/mise/target/release/mise activate nu | save ~/.config/nushell/scripts/mise.gen.nu -f
}

if not ("~/.zoxide.nu" | path exists) {
    zoxide init nushell | save -f ~/.zoxide.nu
}
