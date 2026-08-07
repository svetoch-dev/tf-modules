#!/bin/sh

cd $BUILD_WORKSPACE_DIRECTORY
for t in $(bazel query 'attr(name, "^(lint_fix_tf|lint_fix_bzl)$", "//...")')
do
  echo bazel run $t
  bazel run $t > /dev/null 2>&1
done
