//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Atomics open source project
//
// Copyright (c) 2020-2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//


// #############################################################################
// #                                                                           #
// #            DO NOT EDIT THIS FILE; IT IS AUTOGENERATED.                    #
// #                                                                           #
// #############################################################################


#if BRIGHTENTOOLS
import Atomics.CAtomics
#else
import CAtomics
#endif

extension Bool: AtomicValue {
  @frozen
  public struct AtomicRepresentation {
    public typealias Value = Bool
    @usableFromInline
    internal var _storage: _AtomicBoolStorage

    @inline(__always) @_alwaysEmitIntoClient
    public init(_ value: Bool) {
      _storage = _sa_prepare_Bool(value)
    }

    @inline(__always) @_alwaysEmitIntoClient
    public func dispose() -> Value {
      _sa_dispose_Bool(_storage)
    }
  }
}

extension Bool.AtomicRepresentation {
  @_transparent @_alwaysEmitIntoClient
  @usableFromInline
  static func _extract(
    _ ptr: UnsafeMutablePointer<Self>
  ) -> UnsafeMutablePointer<_AtomicBoolStorage> {
    // `Self` is layout-compatible with its only stored property.
    return UnsafeMutableRawPointer(ptr)
      .assumingMemoryBound(to: _AtomicBoolStorage.self)
  }
}

extension Bool.AtomicRepresentation: AtomicStorage {
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicLoad(
    at pointer: UnsafeMutablePointer<Bool.AtomicRepresentation>,
    ordering: AtomicLoadOrdering
  ) -> Bool {
    switch ordering {
    case .relaxed:
      return _sa_load_relaxed_Bool(_extract(pointer))
    case .acquiring:
      return _sa_load_acquire_Bool(_extract(pointer))
    case .sequentiallyConsistent:
      return _sa_load_seq_cst_Bool(_extract(pointer))
    default:
      fatalError("Unsupported ordering")
    }
  }

  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicStore(
    _ desired: __owned Bool,
    at pointer: UnsafeMutablePointer<Bool.AtomicRepresentation>,
    ordering: AtomicStoreOrdering
  ) {
    switch ordering {
    case .relaxed:
      _sa_store_relaxed_Bool(_extract(pointer), desired)
    case .releasing:
      _sa_store_release_Bool(_extract(pointer), desired)
    case .sequentiallyConsistent:
      _sa_store_seq_cst_Bool(_extract(pointer), desired)
    default:
      fatalError("Unsupported ordering")
    }
  }

  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicExchange(
    _ desired: __owned Bool,
    at pointer: UnsafeMutablePointer<Bool.AtomicRepresentation>,
    ordering: AtomicUpdateOrdering
  ) -> Bool {
    switch ordering {
    case .relaxed:
      return _sa_exchange_relaxed_Bool(_extract(pointer), desired)
    case .acquiring:
      return _sa_exchange_acquire_Bool(_extract(pointer), desired)
    case .releasing:
      return _sa_exchange_release_Bool(_extract(pointer), desired)
    case .acquiringAndReleasing:
      return _sa_exchange_acq_rel_Bool(_extract(pointer), desired)
    case .sequentiallyConsistent:
      return _sa_exchange_seq_cst_Bool(_extract(pointer), desired)
    default:
      fatalError("Unsupported ordering")
    }
  }

  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicCompareExchange(
    expected: Bool,
    desired: __owned Bool,
    at pointer: UnsafeMutablePointer<Bool.AtomicRepresentation>,
    ordering: AtomicUpdateOrdering
  ) -> (exchanged: Bool, original: Bool) {
    var expected = expected
    let exchanged: Bool
    switch ordering {
    case .relaxed:
      exchanged = _sa_cmpxchg_strong_relaxed_relaxed_Bool(
        _extract(pointer),
        &expected, desired)
    case .acquiring:
      exchanged = _sa_cmpxchg_strong_acquire_acquire_Bool(
        _extract(pointer),
        &expected, desired)
    case .releasing:
      exchanged = _sa_cmpxchg_strong_release_relaxed_Bool(
        _extract(pointer),
        &expected, desired)
    case .acquiringAndReleasing:
      exchanged = _sa_cmpxchg_strong_acq_rel_acquire_Bool(
        _extract(pointer),
        &expected, desired)
    case .sequentiallyConsistent:
      exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected, desired)
    default:
      fatalError("Unsupported ordering")
    }
    return (exchanged, expected)
  }

  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicCompareExchange(
    expected: Bool,
    desired: __owned Bool,
    at pointer: UnsafeMutablePointer<Bool.AtomicRepresentation>,
    successOrdering: AtomicUpdateOrdering,
    failureOrdering: AtomicLoadOrdering
  ) -> (exchanged: Bool, original: Bool) {
    var expected = expected
    let exchanged: Bool
    // FIXME: stdatomic.h (and LLVM underneath) doesn't support
    // arbitrary ordering combinations yet, so upgrade the success
    // ordering when necessary so that it is at least as "strong" as
    // the failure case.
    switch (successOrdering, failureOrdering) {
    case (.relaxed, .relaxed):
      exchanged = _sa_cmpxchg_strong_relaxed_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.relaxed, .acquiring):
      exchanged = _sa_cmpxchg_strong_acquire_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.relaxed, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiring, .relaxed):
      exchanged = _sa_cmpxchg_strong_acquire_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiring, .acquiring):
      exchanged = _sa_cmpxchg_strong_acquire_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiring, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.releasing, .relaxed):
      exchanged = _sa_cmpxchg_strong_release_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.releasing, .acquiring):
      exchanged = _sa_cmpxchg_strong_acq_rel_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.releasing, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiringAndReleasing, .relaxed):
      exchanged = _sa_cmpxchg_strong_acq_rel_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiringAndReleasing, .acquiring):
      exchanged = _sa_cmpxchg_strong_acq_rel_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiringAndReleasing, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.sequentiallyConsistent, .relaxed):
      exchanged = _sa_cmpxchg_strong_seq_cst_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.sequentiallyConsistent, .acquiring):
      exchanged = _sa_cmpxchg_strong_seq_cst_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.sequentiallyConsistent, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    default:
      fatalError("Unsupported ordering")
    }
    return (exchanged, expected)
  }

  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicWeakCompareExchange(
    expected: Bool,
    desired: __owned Bool,
    at pointer: UnsafeMutablePointer<Bool.AtomicRepresentation>,
    successOrdering: AtomicUpdateOrdering,
    failureOrdering: AtomicLoadOrdering
  ) -> (exchanged: Bool, original: Bool) {
    var expected = expected
    let exchanged: Bool
    // FIXME: stdatomic.h (and LLVM underneath) doesn't support
    // arbitrary ordering combinations yet, so upgrade the success
    // ordering when necessary so that it is at least as "strong" as
    // the failure case.
    switch (successOrdering, failureOrdering) {
    case (.relaxed, .relaxed):
      exchanged = _sa_cmpxchg_weak_relaxed_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.relaxed, .acquiring):
      exchanged = _sa_cmpxchg_weak_acquire_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.relaxed, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_weak_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiring, .relaxed):
      exchanged = _sa_cmpxchg_weak_acquire_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiring, .acquiring):
      exchanged = _sa_cmpxchg_weak_acquire_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiring, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_weak_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.releasing, .relaxed):
      exchanged = _sa_cmpxchg_weak_release_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.releasing, .acquiring):
      exchanged = _sa_cmpxchg_weak_acq_rel_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.releasing, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_weak_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiringAndReleasing, .relaxed):
      exchanged = _sa_cmpxchg_weak_acq_rel_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiringAndReleasing, .acquiring):
      exchanged = _sa_cmpxchg_weak_acq_rel_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.acquiringAndReleasing, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_weak_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.sequentiallyConsistent, .relaxed):
      exchanged = _sa_cmpxchg_weak_seq_cst_relaxed_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.sequentiallyConsistent, .acquiring):
      exchanged = _sa_cmpxchg_weak_seq_cst_acquire_Bool(
        _extract(pointer),
        &expected,
        desired)
    case (.sequentiallyConsistent, .sequentiallyConsistent):
      exchanged = _sa_cmpxchg_weak_seq_cst_seq_cst_Bool(
        _extract(pointer),
        &expected,
        desired)
    default:
      fatalError("Unsupported ordering")
    }
    return (exchanged, expected)
  }
}


// MARK: - Additional operations

extension Bool.AtomicRepresentation {
  /// Perform an atomic logical AND operation on the value referenced by
  /// `pointer` and return the original value, applying the specified memory
  /// ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter pointer: A memory location previously initialized with a value
  ///   returned by `prepareAtomicRepresentation(for:)`.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicLoadThenLogicalAnd(
    with operand: Value,
    at pointer: UnsafeMutablePointer<Self>,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    switch ordering {
    case .relaxed:
      return _sa_fetch_and_relaxed_Bool(
        _extract(pointer),
        operand)
    case .acquiring:
      return _sa_fetch_and_acquire_Bool(
        _extract(pointer),
        operand)
    case .releasing:
      return _sa_fetch_and_release_Bool(
        _extract(pointer),
        operand)
    case .acquiringAndReleasing:
      return _sa_fetch_and_acq_rel_Bool(
        _extract(pointer),
        operand)
    case .sequentiallyConsistent:
      return _sa_fetch_and_seq_cst_Bool(
        _extract(pointer),
        operand)
    default:
      fatalError("Unsupported ordering")
    }
  }
  /// Perform an atomic logical OR operation on the value referenced by
  /// `pointer` and return the original value, applying the specified memory
  /// ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter pointer: A memory location previously initialized with a value
  ///   returned by `prepareAtomicRepresentation(for:)`.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicLoadThenLogicalOr(
    with operand: Value,
    at pointer: UnsafeMutablePointer<Self>,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    switch ordering {
    case .relaxed:
      return _sa_fetch_or_relaxed_Bool(
        _extract(pointer),
        operand)
    case .acquiring:
      return _sa_fetch_or_acquire_Bool(
        _extract(pointer),
        operand)
    case .releasing:
      return _sa_fetch_or_release_Bool(
        _extract(pointer),
        operand)
    case .acquiringAndReleasing:
      return _sa_fetch_or_acq_rel_Bool(
        _extract(pointer),
        operand)
    case .sequentiallyConsistent:
      return _sa_fetch_or_seq_cst_Bool(
        _extract(pointer),
        operand)
    default:
      fatalError("Unsupported ordering")
    }
  }
  /// Perform an atomic logical XOR operation on the value referenced by
  /// `pointer` and return the original value, applying the specified memory
  /// ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter pointer: A memory location previously initialized with a value
  ///   returned by `prepareAtomicRepresentation(for:)`.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public static func atomicLoadThenLogicalXor(
    with operand: Value,
    at pointer: UnsafeMutablePointer<Self>,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    switch ordering {
    case .relaxed:
      return _sa_fetch_xor_relaxed_Bool(
        _extract(pointer),
        operand)
    case .acquiring:
      return _sa_fetch_xor_acquire_Bool(
        _extract(pointer),
        operand)
    case .releasing:
      return _sa_fetch_xor_release_Bool(
        _extract(pointer),
        operand)
    case .acquiringAndReleasing:
      return _sa_fetch_xor_acq_rel_Bool(
        _extract(pointer),
        operand)
    case .sequentiallyConsistent:
      return _sa_fetch_xor_seq_cst_Bool(
        _extract(pointer),
        operand)
    default:
      fatalError("Unsupported ordering")
    }
  }
}

extension UnsafeAtomic where Value == Bool {
  /// Perform an atomic logical AND operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func loadThenLogicalAnd(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    Value.AtomicRepresentation.atomicLoadThenLogicalAnd(
      with: operand,
      at: _ptr,
      ordering: ordering)
  }
  /// Perform an atomic logical OR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func loadThenLogicalOr(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    Value.AtomicRepresentation.atomicLoadThenLogicalOr(
      with: operand,
      at: _ptr,
      ordering: ordering)
  }
  /// Perform an atomic logical XOR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func loadThenLogicalXor(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    Value.AtomicRepresentation.atomicLoadThenLogicalXor(
      with: operand,
      at: _ptr,
      ordering: ordering)
  }
}

extension UnsafeAtomic where Value == Bool {
  /// Perform an atomic logical AND operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func logicalAndThenLoad(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    let original = Value.AtomicRepresentation.atomicLoadThenLogicalAnd(
      with: operand,
      at: _ptr,
      ordering: ordering)
    return original && operand
  }
  /// Perform an atomic logical OR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func logicalOrThenLoad(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    let original = Value.AtomicRepresentation.atomicLoadThenLogicalOr(
      with: operand,
      at: _ptr,
      ordering: ordering)
    return original || operand
  }
  /// Perform an atomic logical XOR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func logicalXorThenLoad(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    let original = Value.AtomicRepresentation.atomicLoadThenLogicalXor(
      with: operand,
      at: _ptr,
      ordering: ordering)
    return original != operand
  }
}
extension ManagedAtomic where Value == Bool {
  /// Perform an atomic logical AND operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func loadThenLogicalAnd(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    Value.AtomicRepresentation.atomicLoadThenLogicalAnd(
      with: operand,
      at: _ptr,
      ordering: ordering)
  }
  /// Perform an atomic logical OR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func loadThenLogicalOr(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    Value.AtomicRepresentation.atomicLoadThenLogicalOr(
      with: operand,
      at: _ptr,
      ordering: ordering)
  }
  /// Perform an atomic logical XOR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func loadThenLogicalXor(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    Value.AtomicRepresentation.atomicLoadThenLogicalXor(
      with: operand,
      at: _ptr,
      ordering: ordering)
  }
}

extension ManagedAtomic where Value == Bool {
  /// Perform an atomic logical AND operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func logicalAndThenLoad(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    let original = Value.AtomicRepresentation.atomicLoadThenLogicalAnd(
      with: operand,
      at: _ptr,
      ordering: ordering)
    return original && operand
  }
  /// Perform an atomic logical OR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func logicalOrThenLoad(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    let original = Value.AtomicRepresentation.atomicLoadThenLogicalOr(
      with: operand,
      at: _ptr,
      ordering: ordering)
    return original || operand
  }
  /// Perform an atomic logical XOR operation and return the original value, applying
  /// the specified memory ordering.
  ///
  /// - Parameter operand: A boolean value.
  /// - Parameter ordering: The memory ordering to apply on this operation.
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_transparent @_alwaysEmitIntoClient
  public func logicalXorThenLoad(
    with operand: Value,
    ordering: AtomicUpdateOrdering
  ) -> Value {
    let original = Value.AtomicRepresentation.atomicLoadThenLogicalXor(
      with: operand,
      at: _ptr,
      ordering: ordering)
    return original != operand
  }
}
