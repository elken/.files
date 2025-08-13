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
