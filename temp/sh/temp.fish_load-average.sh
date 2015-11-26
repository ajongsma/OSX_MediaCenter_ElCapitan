# Show loadavg when too high
set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
set -l load1m_test (math $load1m \* 100 / 1)
if test $load1m_test -gt 100
    error load $load1m
end
