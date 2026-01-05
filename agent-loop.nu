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
    mut results = []
    for i in 1..$loops {
        print $"($ICON_COPILOT)  ($i)/($loops) ($worktree)"
        let result = (opencode run "Carefully follow instructions in attached file." -m $model -f ../prompt.md | complete)
        $results = ($results | append { loop: $i, exit: $result.exit_code, out: ($result.stdout | str trim) })
    }
    cd ..

    print $"($ICON_COPILOT)  ($worktree): ($loops) loops"
    for r in $results { print $"($ICON_COPILOT)  ($r.loop) exit=($r.exit)\n($r.out)\n" }

    # Message for ORCHESTRATOR agent
    let follow_up = (open follow-up.md)
    print $"
Instructions for main ORCHESTRATOR agent:

($follow_up)
"
}
