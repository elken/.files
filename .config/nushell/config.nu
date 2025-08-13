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

zoxide init nushell | save -f ~/.zoxide.nu
mise activate nu | save ~/.config/nushell/scripts/mise.gen.nu -f

use ~/.config/nushell/scripts/mise.gen.nu
source ~/.zoxide.nu

alias make = make $"-j(sys cpu | length | $in + 1)" $"-l(sys cpu | length)"
alias c = clear
alias q = exit
def ll [] { ls -al | sort-by type name -i | grid -c -i }
def mkdcd [] { mkdir $in and cd $in }

alias yl = lazygit --work-tree ~ --git-dir ~/.local/share/yadm/repo.git

# Get Kubernetes resources with structured output
#
# A wrapper around `kubectl get` that returns structured data parsed from JSON.
# Provides a flattened table view by default, showing the most relevant fields
# for each resource type. Use --raw to get the full JSON structure.
#
# Examples:
#   kget pods                           # Get pods in current namespace
#   kget pods -n my-namespace           # Get pods in specific namespace
#   kget deployments -A                 # Get deployments in all namespaces
#   kget services -l app=myapp          # Get services with label selector
#   kget secrets --raw                  # Get full JSON structure

$env.config.show_banner = false

def kget [
    resource: string                    # The Kubernetes resource type (pods, services, etc.)
    --namespace(-n): string             # Namespace to query (same as kubectl -n)
    --all-namespaces(-A)                # Query all namespaces (same as kubectl -A)
    --selector(-l): string              # Label selector (same as kubectl -l)
    --raw                               # Return full JSON structure instead of flattened table
    ...args                             # Additional kubectl arguments
] {
    mut cmd_args = [$resource]

    if ($namespace | is-not-empty) { $cmd_args = ($cmd_args | append ["-n", $namespace]) }
    if $all_namespaces { $cmd_args = ($cmd_args | append "--all-namespaces") }
    if ($selector | is-not-empty) { $cmd_args = ($cmd_args | append ["-l", $selector]) }

    let all_args = ($cmd_args | append $args | append ["-o", "json"])
    let json_result = (^kubectl get ...$all_args | complete)

    if $json_result.exit_code != 0 {
        error $json_result.stderr
        return
    }

    let json_data = ($json_result.stdout | from json)

    if $raw {
        return $json_data
    }

    let items = if ($json_data | get kind) == "List" { $json_data.items } else { [$json_data] }

     $items | each { |item|
        mut row = {}
        $row.name = $item.metadata.name
        $row.namespace = ($item.metadata.namespace? | default "")
        $row.age = (date now) - ($item.metadata.creationTimestamp | into datetime)

         if ($item | get -o status) != null {
            if ($item.status | get -o phase) != null { $row.status = $item.status.phase }
            if ($item.status | get -o readyReplicas) != null { $row.ready = $item.status.readyReplicas }
        }

        if ($item | get -o spec) != null {
            if ($item.spec | get -o nodeName) != null { $row.node = $item.spec.nodeName }
            if ($item.spec | get -o replicas) != null { $row.replicas = $item.spec.replicas }
            if ($item.spec | get -o type) != null { $row.type = $item.spec.type }
        }

         if ($item | get -o type) != null { $row.type = $item.type }

        $row
    }
}

# Setup zoxide completions
def "nu-complete zoxide path" [context: string] {
    let parts = $context | split row " " | skip 1
    {
      options: {
        sort: false,
        completion_algorithm: substring,
        case_sensitive: false,
      },
      completions: (^zoxide query --list --exclude $env.PWD -- ...$parts | lines),
    }
  }

def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
  __zoxide_z ...$rest
}


$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt | append (source ~/.config/nushell/nu_scripts/nu-hooks/nu-hooks/direnv/config.nu)
)
