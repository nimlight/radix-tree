# Package

version       = "0.1.0"
author        = "flywind"
description   = "Radix Tree."
license       = "BSD 3-Clause"
srcDir        = "src"



# Dependencies

requires "nim >= 1.0.0"

task tests, "Run all tests":
  exec "nim c -r tests/test.nim"
