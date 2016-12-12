//
//  main.swift
//  MachineLearning
//
//  Created by Stewart Charles on 12/11/16.
//  Copyright © 2016 Stewart Charles. All rights reserved.
//

import Foundation

let u = MlVec(1.0,2.0,3.0)
let v = MlVec(1.0,1.0,1.0)
var test = u + v
assert(test == MlVec(2.0,3.0,4.0))
test = u - v
assert(test == MlVec(0.0,1.0,2.0))
test = u / u
assert(test == MlVec(1.0,1.0,1.0))
test = u * u
assert(test == MlVec(1.0,4.0,9.0))

assert(v * 2.0 == 2.0 * v && v * 2.0 == MlVec(2.0,2.0,2.0))
assert(u.dot(rhs:u) == 14.0)
print("Tests Passed")
