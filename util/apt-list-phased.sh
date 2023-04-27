#!/bin/bash -e

if ! command -v apt &>/dev/null; then
    echo "apt not available, nothing to check"
    exit
fi

mapfile -t avail_pkgs < <(apt list --upgradable 2>/dev/null | grep / | cut -f1 -d/)

if [[ ${#avail_pkgs[@]} -eq 0 ]]; then
    echo "No packages available for upgrade"
    exit 0
fi
max_len=0
declare -A phased_pkgs
declare -a unphased_pkgs
for pkg_name in "${avail_pkgs[@]}"; do
    phased=$(apt-cache policy "$pkg_name" | grep -oP '(phased \d+%)' || true)
    if [[ -n $phased ]]; then
        if ((${#pkg_name} > max_len)); then
            max_len=${#pkg_name}
        fi
        phased_pkgs["$pkg_name"]="$phased"
    else
        unphased_pkgs+=("$pkg_name")
    fi
done

if ((${#phased_pkgs[@]} == 0)); then
    echo "No packages are phased"
    exit 0
elif ((${#phased_pkgs[@]} == ${#avail_pkgs[@]})); then
    echo "All available packages are phased"
else
    echo "${#phased_pkgs[@]} of ${#avail_pkgs[@]} packages are phased"
fi
for pkg in "${!phased_pkgs[@]}"; do
    printf "  %-${max_len}s  %s\n" "$pkg" "${phased_pkgs[$pkg]}"
done | sort
if ((${#unphased_pkgs[@]} > 0)); then
    echo "The following packages are not phased:"
    for pkg in "${unphased_pkgs[@]}"; do
        echo "  $pkg"
    done
fi
