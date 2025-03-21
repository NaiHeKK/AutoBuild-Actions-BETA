#!/bin/bash
ECHO() {
	echo "[$(date "+%H:%M:%S")] $*"
}

function Patch_File() {
  parent_path=$1
  patch_file_path=$2
  base_path=$PWD
  cp -r "../Patch-Files/$patch_file_path" "$parent_path"
  ls -R "$parent_path"
  cd "$parent_path"
  for packagepatch in "$patch_file_path"/*; do
    # 检查是否是普通文件 (可选，但推荐)
    if [ -f "$packagepatch" ]; then
      patch_file=$(basename "$packagepatch")
      ECHO Applying Patch File "$patch_file"
      patch -p1 --no-backup-if-mismatch < "$patch_file_path/$patch_file"
    fi
  done
  cd "$base_path"
}

cat feeds/packages/lang/rust/Makefile
Patch_File feeds/packages feeds-package-patch-files
cat feeds/packages/lang/rust/Makefile