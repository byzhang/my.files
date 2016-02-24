[[ -f /tmp/enable-amd-compute ]] && source /tmp/enable-amd-compute
which amdconfig &> /dev/null && export DISPLAY=:0
[[ -f /etc/profile.d/AMDAPPSDK.sh ]] && source /etc/profile.d/AMDAPPSDK.sh
