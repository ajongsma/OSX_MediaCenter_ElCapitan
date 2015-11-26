# Show disk usage when low
set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
if test $du -gt 80
    error du $du%%
end
