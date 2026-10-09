# MaclinOS VM Tests
#
# Automated test scripts for VM-based testing.
#
# Tests should be run inside a QEMU/KVM or VirtualBox VM
# running the MaclinOS ISO or installed system.
#
# Test categories:
#   boot-test.sh       - Verify ISO boots to desktop
#   install-test.sh    - Verify installation completes
#   theme-test.sh      - Verify theme is correctly applied
#   update-test.sh     - Verify apt update/upgrade works
#   recovery-test.sh   - Verify TTY and theme recovery
