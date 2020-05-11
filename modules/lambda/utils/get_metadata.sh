#!/usr/bin/env bash

# Parses a given "build.info" file and expects file to contain key=value per line

# build.info
# git_hash=

set -x

declare DATA_TYPE=$1
declare PACKAGE_PATH=$1
declare -r DEFAULT_BUILD_INFO_FILE="build.info"

_get_package_dir() {
  echo $(dirname $PACKAGE_PATH)
}

_get_build_info_path() {
  package_dir="$1"
  echo "$(dirname $PACKAGE_PATH)/${DEFAULT_BUILD_INFO_FILE}"
}

get_git_hash() {
  build_info_path="$1"

  echo $(grep ^git_hash $build_info_path | cut -f2 -d=)
}

print_json_response() {
  response="$1"

  jq -n --arg response "$response" '{"response":$response}'
}

main() {
  local package_dir=""
  local build_info_path=""
  local response=""

  package_dir=$(_get_package_dir)
  build_info_path=$(_get_build_info_path $package_dir)

  case "$DATA_TYPE" in
    git_hash)
      response=$(get_git_hash $build_info_path)
      ;;
    *)
      echo $"Usage: $0 {git_hash}"
      exit 1
  esac

  print_json_response $response
}
