import strutils, tables

## 
## Radix Tree Module
## 

const
  treeTable = {'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6,
               'h': 7, 'i': 8, 'j': 9, 'k': 10, 'l': 11, 'm': 12, 'n': 13,
               'o': 14, 'p': 15, 'q': 16, 'r': 17, 's': 18, 't': 19, 'u': 20,
               'v': 21, 'w': 22, 'x': 23, 'y': 24, 'z': 25, '/': 26}.toTable
  SIZE = treeTable.len

type
  NodeObj* = object
    value: string
    children: seq[Node]
    isLeaf: bool
    hasValue: bool # -> handler
  Node* = ref NodeObj


proc newNode*(value: string, isLeaf = true, hasValue = true): Node {.inline.} =
  ## Create new Node.
  Node(value: value, children: newSeq[Node](SIZE), isLeaf: isLeaf,
      hasValue: hasValue)

proc toString(root: Node, level: int): string =
  ## Convert Node to string.
  var level = level
  if root.value.len != 0:
    result.add indent(root.value, level) & "\n"
    level += root.value.len
  for child in root.children:
    if not child.isNil:
      result.add toString(child, level)

proc `$`*(root: Node): string =
  ## Convert Node to string.
  result = toString(root, 0)

proc toNum(s: char): int {.inline.} =
  treeTable[s]

proc longestPrefix*(s1, s2: string): int {.inline.} =
  ## Longgest prefix of two strings
  let length = min(s1.len, s2.len)
  var idx = 0
  while idx < length:
    if s1[idx] != s2[idx]:
      break
    inc(idx)
  result = idx

proc insertNode*(root: Node, node: Node) =
  ## Insert Node
  let
    value = node.value
    length = value.len
  if length == 0:
    return
  var origin = root.children[toNum(value[0])]
  if origin.isNil:
    root.children[toNum(value[0])] = node
  else:
    let
      idx = longestPrefix(value, origin.value)
      L1 = length
      L2 = origin.value.len
    if idx == L1 and idx == L2:
      # match all
      origin.hasValue = true
    elif idx < L1 and idx < L2:
      # insert -> prologue 
      # origin -> proper
      if not origin.isLeaf:
        var node = newNode(origin.value[idx .. ^1], hasValue = origin.hasValue)
        swap(node.children, origin.children)
        insertNode(origin, node)
        insertNode(origin, newNode(value[idx .. ^1], hasValue = true))
        origin.value = origin.value[0 ..< idx]
        origin.isLeaf = false
        origin.hasValue = false
      else:
        # leaf node
        insertNode(origin, newNode(value[idx .. ^1], hasValue = origin.hasValue))
        insertNode(origin, newNode(origin.value[idx .. ^1], hasValue = true))
        origin.value = origin.value[0 ..< idx]
        origin.isLeaf = false
        origin.hasValue = false
    elif idx < L1:
      # insert -> prologue 
      # origin -> pro
      insertNode(origin, newNode(value[idx .. ^1], hasValue = true))
      # if origin.isLeaf:
      #   origin.hasValue = true
      origin.isLeaf = false
    elif idx < L2:
      # insert -> pro
      # origin -> prologue
      insertNode(origin, newNode(origin.value[idx .. ^1], hasValue = origin.hasValue))
      origin.value = origin.value[0 ..< idx]
      origin.hasValue = true
      origin.isLeaf = false

  # if not origin.isNil:
  #   echo "value: ", origin.value
  #   echo "hasValue: ", origin.hasValue
  #   echo "isLeaf: ", origin.isLeaf

proc insert*(root: Node, value: string) =
  ## Insert value.
  root.insertNode(newNode(value))

proc search*(root: Node, value: string): bool =
  ## Search value.
  let length = value.len
  let origin = root.children[toNum(value[0])]
  if origin == nil:
    return false
  else:
    let idx = longestPrefix(origin.value, value)
    if idx < origin.value.len:
      return false
    elif idx < length:
      return search(origin, value[idx .. ^1])
    if not origin.hasValue:
      return false
    return true


when isMainModule:
  import unittest
 
  var root = newNode("")
  root.insert("python")
  root.insert("pyiju")
  root.insert("pyth")
  root.insert("pyerl")
  root.insert("pyern")
  root.insert("python")
  root.insert("pyth")
  root.insert("")
  root.insert("pok")
  root.insert("pyerl")
  root.insert("pyera")
  root.insert("io")
  root.insert("ioo")
  root.insert("iopen")

  suite "Test Radix Tree":
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
      check root.search("pok")
      check not root.search("poka")
      check not root.search("bok")
  echo root.search("iopen")
  echo root
