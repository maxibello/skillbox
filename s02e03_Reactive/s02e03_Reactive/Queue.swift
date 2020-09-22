//
//  Queue.swift
//  s02e03_Reactive
//
//  Created by Максим on 22.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

struct Queue<T> {
  private var elements: [T] = []

  mutating func enqueue(_ value: T) {
    elements.append(value)
  }

  mutating func dequeue() -> T? {
    guard !elements.isEmpty else {
      return nil
    }
    return elements.removeFirst()
  }

  var head: T? {
    return elements.first
  }

  var tail: T? {
    return elements.last
  }
}
