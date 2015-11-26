# Git branch and dirty files
git_branch
if set -q git_branch
    set out $git_branch
    if test $git_dirty_count -gt 0
        set out "$out$c0:$ce$git_dirty_count"
    end
    section git $out
end
