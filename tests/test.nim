import ../radix_tree/src/radix_tree


import unittest


suite "Test Radix Tree":
  var root = newNode("")
  root.insert("python")
  root.insert("pyiju")
  root.insert("pyth")
  root.insert("pyerl")
  root.insert("pyern")
  root.insert("python")
  root.insert("pyth")
  root.insert("pyerl")
  root.insert("pyera")
  root.insert("io")
  root.insert("ioo")
  root.insert("iopen")

  test "search":
    check root.search("io")
    check root.search("ioo")
    check root.search("iopen")
    check not root.search("py")
    check root.search("pyerl")
    check root.search("pyern")
    check root.search("pyth")
    check root.search("python")
    check root.search("pyiju")
    check not root.search("pyer")
    check not root.search("pythonic")
