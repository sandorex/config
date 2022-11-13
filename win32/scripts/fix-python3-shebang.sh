#!/bin/sh
#
# (https://github.com/sandorex/config)
# fix-python.sh - creates python3 wrapper script that runs python 3
#
# Copyright 2019-2022 Aleksandar Radivojevic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	 http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# prevent from running on anything but windows
case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
   windows*|mingw*|cygwin*|msys*)
      ;;
   *)
      echo "This script was intended for windows only"
      exit 1
      ;;
esac

if [ -f /bin/python3 ]; then
   echo "/bin/python3 already exists"
   exit
fi

# (https://stackoverflow.com/a/11995662)
# test for administrator priviledges
#cmd.exe /C "net session >nul 2>&1"
#if [ "$?" == "2" ]; then
#   echo -e "Please run this script with administrator priviledges"
#   exit 1
#fi

if [ -z "$1" ]; then
   echo "Please provide path to python 3 executable"
   echo -e "\nFound python in PATH at:"
   cmd.exe /C "where python"
   exit 1
fi

cat << EOF > /bin/python3
#!/bin/sh
# WRAPPER SCRIPT THAT RUNS python 3 ON WINDOWS
exec "$1" \$@
EOF
