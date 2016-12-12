//
//  nvec.swift
//  MachineLearning
//
//  Created by Stewart Charles on 12/11/16.
//  Copyright © 2016 Stewart Charles. All rights reserved.
//

import Foundation
class MlVec {
  
  var data : [Float64]
  
  init(_ d:[Float64]) {
    data = d
  }
  
  init(_ d: Float64 ...) {
    data = d
  }
  
  func len() -> Int {
    return data.count
  }
  
  func map(fn:(Float64)->Float64)-> MlVec {
    var arr = [Float64] (repeating: 0.0, count: len())
    for i in 0..<len() {
      arr[i] = fn(data[i])
    }
    return MlVec(arr)
  }
  
  func map(rhs:MlVec, fn:(Float64,Float64)->Float64)->MlVec {
    var arr = [Float64] (repeating: 0.0, count: len())
    for i in 0..<len() {
      arr[i] = fn(data[i], rhs[i])
    }
    return MlVec(arr)
  }
  
  func fold(fn:(Float64,Float64)->Float64,accum:Float64)->Float64 {
    var ans = accum
    for i in 0..<len() {
      ans = fn(data[i],ans)
    }
    return ans
  }
  
  func fold(rhs:MlVec,fn:(Float64,Float64,Float64)->Float64,accum:Float64) -> Float64 {
    var ans = accum
    for i in 0..<len() {
      ans = fn(data[i],rhs[i],ans)
    }
    return ans
  }
  
  func add(rhs:MlVec)->MlVec {
    return map(rhs:rhs,fn:{(a: Float64, b : Float64)->Float64 in a + b})
  }
  
  func sub(rhs:MlVec)->MlVec {
    return map(rhs:rhs,fn:{(a: Float64, b : Float64)->Float64 in a - b})
  }
  
  func mul(rhs:MlVec)->MlVec {
    return map(rhs:rhs,fn:{(a: Float64, b : Float64)->Float64 in a * b})
  }
  
  func div(rhs:MlVec)->MlVec {
    return map(rhs:rhs,fn:{(a: Float64, b : Float64)->Float64 in a / b})
  }
  
  func add(rhs:Float64)->MlVec {
    return map(fn:{(a: Float64)->Float64 in a + rhs})
  }
  
  func sub(rhs:Float64)->MlVec {
    return map(fn:{(a: Float64)->Float64 in a - rhs})
  }
  
  func mul(rhs:Float64)->MlVec {
    return map(fn:{(a: Float64)->Float64 in a * rhs})
  }
  
  func div(rhs:Float64)->MlVec {
    return mul(rhs:rhs)
  }
  
  func dot(rhs:MlVec)->Float64 {
    return fold(rhs:rhs, fn:{(a: Float64, b: Float64, c:Float64)->Float64 in a * b + c}, accum:0.0)
  }
  
  static func +(_ lhs:MlVec,_ rhs:MlVec)->MlVec {
    return lhs.add(rhs: rhs)
  }
  
  static func -(_ lhs:MlVec,_ rhs:MlVec)->MlVec {
    return lhs.sub(rhs: rhs)
  }
  
  static func /(_ lhs:MlVec,_ rhs:MlVec)->MlVec {
    return lhs.div(rhs: rhs)
  }
  
  static func *(_ lhs:MlVec,_ rhs:MlVec)->MlVec {
    return lhs.mul(rhs: rhs)
  }
  
  static func +(_ lhs:MlVec,_ rhs:Float64)->MlVec {
    return lhs.add(rhs: rhs)
  }
  
  static func -(_ lhs:MlVec,_ rhs:Float64)->MlVec {
    return lhs.sub(rhs: rhs)
  }
  
  static func *(_ lhs:MlVec,_ rhs:Float64)->MlVec {
    return lhs.mul(rhs: rhs)
  }
  
  static func /(_ lhs:MlVec,_ rhs:Float64)->MlVec {
    return lhs.div(rhs: rhs)
  }
  
  static func *(_ lhs:Float64,_ rhs:MlVec)->MlVec {
    return rhs.mul(rhs: lhs)
  }
  
  static func ==(_ lhs:MlVec,_ rhs: MlVec)->Bool {
    let size = Float64(lhs.len())
    let test = lhs.fold(rhs: rhs,
                        fn: {(a:Float64,b:Float64,c:Float64)->Float64 in
                         let test = a == b
                         return (c + (test ? 1.0 : 0.0))},
                        accum: 0.0)
    return size == test
  }
  
  static func !=(_ lhs:MlVec,_ rhs: MlVec)->Bool {
    return !(lhs == rhs)
  }
  
  subscript(_ index:Int)->Float64 {
    get { return data[index] }
    set { data[index] = newValue }
  }
  
}
