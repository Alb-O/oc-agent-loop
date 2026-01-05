def main [
    worktree: string = "main"
    --loops (-l): int = 2
    --model (-m): string = "anthropic/claude-opus-4-5"
] {
    let worktree_path = $"./($worktree)"

    if not ($worktree_path | path exists) {
        let result = (git worktree add $worktree_path $worktree | complete)
        if $result.exit_code != 0 {
            git worktree add -b $worktree $worktree_path HEAD
        }
    }

    cd $worktree_path
    mut results = []
    for i in 1..$loops {
        print $"  ($i)/($loops) ($worktree)"
        let result = (opencode run "Carefully follow instructions in attached file." -m $model -f ../prompt.md | complete)
        $results = ($results | append { loop: $i, exit: $result.exit_code, out: ($result.stdout | str trim) })
    }

    print $"  ($worktree): ($loops) loops"
    for r in $results { print $"  ($r.loop) exit=($r.exit)\n($r.out)\n" }
}
