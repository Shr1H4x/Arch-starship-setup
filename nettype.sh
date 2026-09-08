
#!/usr/bin/env bash
# helper for starship
p=$(nmcli -t device status 2>/dev/null | grep ':connected:' | head -1 | cut -d: -f2)
case "$p" in
  ethernet)
    echo "󰈀"
    ;;
  wifi)
    s=$(nmcli -t -f IN-USE,SIGNAL device wifi list 2>/dev/null | awk -F: '/^\*/ {print $2; exit}')
    [ -z "$s" ] && s=$(nmcli -t -f IN-USE,SIGNAL device wifi list 2>/dev/null | awk -F: 'NR==1 {print $2; exit}')
    [ -z "$s" ] && s=40
    i=$(( s / 20 ))
    [ "$i" -lt 0 ] && i=0
    [ "$i" -gt 4 ] && i=4
    case "$i" in
      0) echo "󰤯";;
      1) echo "󰤟";;
      2) echo "󰤢";;
      3) echo "󰤥";;
      4) echo "󰤨";;
    esac
    ;;
  *)
    echo "󰤮"
    ;;
esac
