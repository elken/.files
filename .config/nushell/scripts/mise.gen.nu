export-env {
  $env.PATH = r#'/Users/ellis.kenyo/.rbenv/shims:/Users/ellis.kenyo/.ghcup/bin:/Users/ellis.kenyo/.local/share/nvim/mason/bin:/home/linuxbrew/.linuxbrew/lib/ruby/gems/3.3.0/bin:/Users/ellis.kenyo/.babashka/bbin/bin:/Users/ellis.kenyo/.qlot/bin:/Users/ellis.kenyo/.config/emacs/bin:/Users/ellis.kenyo/.cargo/bin:/Users/ellis.kenyo/bin:/Users/ellis.kenyo/.local/bin:/Users/ellis.kenyo/.config/yarn/global/node_modules/.bin:/Users/ellis.kenyo/.dotnet/tools:/Users/ellis.kenyo/spicetify-cli:/Users/ellis.kenyo/.luarocks/bin:/Users/ellis.kenyo/build/phpactor/bin:/Users/ellis.kenyo/go/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/Applications/Emacs.app/Contents:/Applications/Emacs.app/Contents/bin:/usr/local/opt/coreutils/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/opt/openjdk/bin:/Users/elken/flutter/sdk/bin:/opt/homebrew/bin:/System/Cryptexes/App/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/opt/homebrew/opt/openjdk@11/bin:/Users/ellis.kenyo/flutter/sdk/bin:/Users/ellis.kenyo/.ghcup/bin:/Users/ellis.kenyo/.rbenv/shims:/Users/ellis.kenyo/.local/share/nvim/mason/bin:/Users/ellis.kenyo/.babashka/bbin/bin:/Users/ellis.kenyo/.qlot/bin:/Users/ellis.kenyo/.config/emacs/bin:/Users/ellis.kenyo/.cargo/bin:/Users/ellis.kenyo/bin:/Users/ellis.kenyo/.local/bin:/Users/ellis.kenyo/.config/yarn/global/node_modules/.bin:/Users/ellis.kenyo/.dotnet/tools:/Users/ellis.kenyo/.luarocks/bin:/Users/ellis.kenyo/go/bin:/Users/ellis.kenyo/.rbenv/shims:/Users/ellis.kenyo/code/emacs/nextstep/Emacs.app/Contents/MacOS/libexec'#
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/opt/homebrew/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/opt/homebrew/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/opt/homebrew/bin/mise" $command ...$rest
  }
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if $var.name == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}

def --env mise_hook [] {
  ^"/opt/homebrew/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}
