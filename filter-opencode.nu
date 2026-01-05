# Filter opencode JSON output for cleaner monitoring
# Pipe JSON lines through this to get concise output

# Shorten paths by removing common prefixes
def shorten-path []: string -> string {
    $in 
    | str replace -r '^/home/[^/]+/@/dev/[^/]+/@/' '' 
    | str replace -r '^/home/[^/]+/' '~/'
}

def main [] {
    open /dev/stdin | lines | each { |line|
        # Skip empty lines or non-JSON
        if ($line | str trim | is-empty) { return null }
        if not ($line | str starts-with "{") { return null }
        
        let event = try { $line | from json } catch { return null }
        let etype = ($event | get -o type | default "")
        
        if $etype == "tool_use" {
            let tool = ($event | get -o part.tool | default "?")
            # Skip noisy tools
            if $tool in ["todowrite", "todoread"] { return null }
            
            let status = ($event | get -o part.state.status | default "?")
            let input = ($event | get -o part.state.input | default {})
            
            # Get description based on tool type
            let desc = if $tool == "bash" {
                let d = ($input | get -o description | default "")
                if ($d | is-empty) {
                    ($input | get -o command | default "" | str substring 0..60)
                } else { $d }
            } else if $tool == "read" {
                ($input | get -o filePath | default "" | shorten-path)
            } else if $tool == "edit" {
                let f = ($input | get -o filePath | default "" | shorten-path)
                $"($f)"
            } else if $tool == "glob" {
                ($input | get -o pattern | default "")
            } else if $tool == "grep" {
                let p = ($input | get -o pattern | default "")
                let inc = ($input | get -o include | default "")
                if ($inc | is-empty) { $"'($p)'" } else { $"'($p)' (($inc))" }
            } else if $tool == "write" {
                ($input | get -o filePath | default "" | shorten-path)
            } else {
                ""
            }
            
            let icon = if $status == "completed" { "✓" } else if $status == "running" { "…" } else { "○" }
            let color = if $status == "completed" { "green" } else if $status == "running" { "yellow" } else { "cyan" }
            
            print $"(ansi $color)($icon) ($tool | fill -w 6)(ansi reset) ($desc)"
        } else if $etype == "text" {
            # Agent's text output/thoughts - show first line only
            let text = ($event | get -o part.text | default "")
            if not ($text | is-empty) {
                let clean = ($text | str trim | split row "\n" | first)
                if ($clean | str length) > 100 {
                    print $"(ansi yellow)» ($clean | str substring 0..100)...(ansi reset)"
                } else {
                    print $"(ansi yellow)» ($clean)(ansi reset)"
                }
            }
        }
        null
    } | ignore
}
