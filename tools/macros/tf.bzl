"""Tf macros"""

load(
    "@rules_tf//tf:defs.bzl",
    "tf_fmt_test",
    "tf_init",
    "tf_validate_test",
)

def tf_test(
        name = None,
        extra_srcs = []):
    """Creates common tf targets

    Args:
        name: unused arg to stick with conventions
        extra_srcs: additional source files that need to be added to
            common tf targets
    """

    native.filegroup(
        name = "srcs",
        srcs = native.glob(
            [
                "**/*.tf",
                "*.tf",
                "**/*.tpl",
            ],
            allow_empty = True,
        ) + extra_srcs,
        visibility = ["//visibility:public"],
    )

    tf_validate_test(
        name = "validate",
        srcs = [":srcs"],
        init = ":init_for_tests",
    )

    tf_fmt_test(
        name = "lint",
        srcs = [":srcs"],
    )

    tf_init(
        name = "init_for_tests",
        srcs = [":srcs"],
        backend = False,
    )
