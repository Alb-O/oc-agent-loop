def main [
    worktree: string = "main"
    --loops (-l): int = 2
    --model (-m): string = "anthropic/claude-opus-4-5"
] {
    use icons.nu *

    let worktree_path = $"./($worktree)"

    # Create worktree from main's git repo if needed
    if not ($worktree_path | path exists) {
        cd main
        let result = (git worktree add $"../($worktree)" $worktree | complete)
        if $result.exit_code != 0 {
            git worktree add -b $worktree $"../($worktree)" HEAD
        }
        cd ..
    }

    cd $worktree_path
    let separator = "" | fill -c "─" -w 60
    mut results = []
    for i in 1..$loops {
        print $"($ICON_COPILOT)  Loop ($i)/($loops) starting in ($worktree)..."
        print $"(ansi cyan)($separator)(ansi reset)"
        
        # Run opencode directly - stdout streams live to terminal
        # Auto-approve all permission requests
        with-env { OPENCODE_PERMISSION: '{ "*": "allow" }' } {
            opencode run "Carefully follow instructions in attached file." -m $model --variant "high" -f ../prompt.md
        }
        let exit_code = $env.LAST_EXIT_CODE? | default 0
        
        print $"(ansi cyan)($separator)(ansi reset)"
        print $"($ICON_COPILOT)  Loop ($i)/($loops) finished with exit=($exit_code)"
        $results = ($results | append { loop: $i, exit: $exit_code })
    }
    cd ..

    print $"\n($ICON_COPILOT)  Summary: ($worktree) - ($loops) loops"
    for r in $results { print $"  Loop ($r.loop): exit=($r.exit)" }

    # Message for ORCHESTRATOR agent
    if ("follow-up.md" | path exists) {
        let follow_up = (open follow-up.md)
        print $"\nInstructions for main ORCHESTRATOR agent:\n($follow_up)"
    }
}
