// swift-tools-version:5.3
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2020-2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
  name: "swift-atomics",
  products: [
    .library(
      name: "Atomics",
      targets: ["CAtomics","Atomics"]),
  ],
  targets: [
    .target(
      name: "CAtomics",
      exclude: [
        "CMakeLists.txt"
      ],
      path: "CSources"),
    ),
    .target(
      name: "Atomics",
      dependencies: ["CAtomics"],
      exclude: [
        "CMakeLists.txt",
        "Atomics.docc",
        "HighLevelTypes.swift.gyb",
        "PointerConformances.swift.gyb",
        "IntegerConformances.swift.gyb",
        "AtomicBool.swift.gyb",
        "AtomicLazyReference.swift.gyb",
      ]
    ),
    .testTarget(
      name: "AtomicsTests",
      dependencies: ["Atomics"],
      exclude: [
        "main.swift",
        "Basics.swift.gyb"
      ]
    ),
  ]
)
