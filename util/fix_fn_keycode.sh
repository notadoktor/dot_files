#!/bin/bash -e

# removes annoying syslog spam when using fn-key
#
# kernel: [ 4861.792967] atkbd serio0: Unknown key released (translated set 2, code 0xf8 on isa0060/serio0).
# kernel: [ 4861.792979] atkbd serio0: Use 'setkeycodes e078 <keycode>' to make it known.

sudo setkeycodes e078 464

