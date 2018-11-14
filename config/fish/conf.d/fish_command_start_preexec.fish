# Modifiled file from:
# https://github.com/jichu4n/fish-command-timer/blob/28871b3ce1bc7a1adc92a3e92d1c3182eef23c69/conf.d/fish_command_timer.fish
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                             #
#    Copyright (C) 2016 Chuan Ji <jichu4n@gmail.com>                          #
#                                                                             #
#    Licensed under the Apache License, Version 2.0 (the "License");          #
#    you may not use this file except in compliance with the License.         #
#    You may obtain a copy of the License at                                  #
#                                                                             #
#     http://www.apache.org/licenses/LICENSE-2.0                              #
#                                                                             #
#    Unless required by applicable law or agreed to in writing, software      #
#    distributed under the License is distributed on an "AS IS" BASIS,        #
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#    See the License for the specific language governing permissions and      #
#    limitations under the License.                                           #
#                                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# A fish shell script for printing start time for each command.
#
# It complements the fish_command_timer.fish script.

# SETTINGS
# ========
#
# Whether to enable the command timer by default.
#
# To temporarily disable the printing of timing information, type the following
# in a session:
#     set fish_command_start_preexec_enabled 0
# To re-enable:
#     set fish_command_start_preexec_enabled 1
if not set -q fish_command_start_preexec_enabled
  set fish_command_start_preexec_enabled 1
end

# The color of the output.
#
# This should be a color string accepted by fish's set_color command, as
# described here:
#
#     http://fishshell.com/docs/current/commands.html#set_color
#
# If empty, disable colored output. Set it to empty if your terminal does not
# support colors.
if not set -q fish_command_start_preexec_color
  set fish_command_start_preexec_color blue
end

# The display format of the current time.
#
# This is a strftime format string (see http://strftime.org/). To tweak the
# display format of the current time, change the following line to your desired
# pattern.
#
# If empty, disables printing of current time.
if not set -q fish_command_start_preexec_time_format
  set fish_command_start_preexec_time_format '%b %d %I:%M%p'
end

# IMPLEMENTATION
# ==============

# fish_command_start_preexec_print_time:
#
# Command to print out a timestamp using fish_command_start_preexec_time_format. The
# timestamp should be in seconds. This is required because the "date" command in
# Linux and OS X use different arguments to specify the timestamp to print.
if date --date='@0' '+%s' > /dev/null ^ /dev/null
  # Linux.
  function fish_command_start_preexec_print_time
    date --date="@$argv[1]" +"$fish_command_start_preexec_time_format"
  end
else if date -r 0 '+%s' > /dev/null ^ /dev/null
  # macOS / BSD.
  function fish_command_start_preexec_print_time
    date -r "$argv[1]" +"$fish_command_start_preexec_time_format"
  end
else
  echo 'No compatible date commands found, not enabling fish command start preexec'
  set fish_command_start_preexec_enabled 0
end

# fish_command_start_preexec_strlen:
#
# Command to print out the length of a string. This is required because the expr
# command behaves differently on Linux and OS X. On fish 2.3+, we will use the
# "string" builtin.
if type string > /dev/null ^ /dev/null
  function fish_command_start_preexec_strlen
    string length "$argv[1]"
  end
else if expr length + "1" > /dev/null ^ /dev/null
  function fish_command_start_preexec_strlen
    expr length + "$argv[1]"
  end
else if type wc > /dev/null ^ /dev/null; and type tr > /dev/null ^ /dev/null
  function fish_command_start_preexec_strlen
    echo -n "$argv[1]" | wc -c | tr -d ' '
  end
else
  echo 'No compatible string, expr, or wc commands found, not enabling fish command start preexec'
  set fish_command_start_preexec_enabled 0
end

# Computes whether the preexec hooks should echo.
function fish_command_start_preexec_echo
  begin
    set -q fish_command_start_preexec_enabled; and \
    [ "$fish_command_start_preexec_enabled" -ne 0 ]
  end
end

# The fish_preexec event is fired before executing a command line.
function fish_command_start_preexec -e fish_preexec
  if not fish_command_start_preexec_echo
    return
  end

  set -l command_start_time (date '+%s')

  set -l now_str (fish_command_start_preexec_print_time $command_start_time)
  set -l output_str
  if [ -n "$now_str" ]
    set output_str "[ $now_str ]"
  else
    set output_str "[ Unknown Start ]"
  end
  set -l output_str_colored
  if begin
       set -q fish_command_start_preexec_color; and \
       [ -n "$fish_command_start_preexec_color" ]
     end
    if [ -n "$now_str" ]
      set output_str_colored "["(set_color $fish_command_start_preexec_color)" $now_str "(set_color normal)"]"
    else
      set output_str_colored "["(set_color $fish_command_start_preexec_color)" Unknown Start "(set_color normal)"]"
    end
  else
    set output_str_colored "$output_str"
  end
  set -l output_str_length (fish_command_start_preexec_strlen "$output_str")

  # Move to the end of the line. This will NOT wrap to the next line.
  echo -ne "\033["{$COLUMNS}"C"
  # Move back (length of output_str) columns.
  echo -ne "\033["{$output_str_length}"D"
  # Finally, print output.
  echo -e "$output_str_colored"
end
