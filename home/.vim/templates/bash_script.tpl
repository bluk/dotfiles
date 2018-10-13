#!/usr/bin/env /bin/bash

# Copyright 2018 Bryant Luk
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Exit immediately if any command has a non-zero exit code
set -e

# Unbound variables cause an error
set -u

# If any command in a pipe command chain fails, the whole pipe fails
set -o pipefail

# Sets the Internal Field Separator so only newlines and tabs split. By default space would be included.
IFS=$'\n\t'
