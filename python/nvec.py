import array

"""
    Vector Library for Machine Learning:
    Author: Stewart Charles
    Version: 1.0
"""
class MlVec(object):
    # Initialize MlVec with Data
    def __init__(self, data, type='d'):
        self.data = array.array(type,data)
        self.dim = len(self.data)
        self.type = type

        # Mapping Function
    def map(self,fn,rhs = None):
        ans = MlVec.of_size(self.dim,self.type)
        if rhs is None:
            for i in range(0,self.dim):
                ans[i] = fn(self[i])
        else:
            if not isinstance(rhs,MlVec):
                for i in range(0,self.dim):
                    ans[i] = fn(self[i],rhs)
            else:
                for i in range(0,self.dim):
                    ans[i] = fn(self[i],rhs[i])
        return ans

    # Fold Function
    def fold(self,fn,rhs = None, accum = 0):
        if rhs is None:
            for i in range(0, self.dim):
                accum = fn(self[i],accum)
        else:
            if not isinstance(rhs,MlVec):
                for i in range(0, self.dim):
                    accum = fn(self[i],rhs,accum)
            else:
                for i in range(0, self.dim):
                    accum = fn(self[i],rhs[i],accum)
        return accum

    # Create an empty MlVec initialized to Zero
    @classmethod
    def of_size(cls,size,type = 'd'):
        return cls([0] * size, type)

    # Operator Overload for [] get
    def __getitem__(self,pos):
        return self.data[pos]

    # Operator Overload for [] set
    def __setitem__(self,pos,item):
        self.data[pos] = item

    # -- Arithmatic Operators --

    def __add__(self,rhs):
        return self.map(lambda a,b: a + b, rhs)

    def __sub__(self,rhs):
        return self.map(lambda a,b: a - b, rhs)

    def __mul__(self,rhs):
        return self.map(lambda a,b: a * b, rhs)

    def __div__(self,rhs):
        if not isinstance(rhs, MlVec):
            return self * (1.0 / rhs)
        else:
            return self.map(lambda a,b: a / b, rhs)

    def dot(self,rhs):
        return self.fold(lambda a,b,c: c + a * b, rhs)

    # Overload the Power operator for MlVec to Performa Dot Product
    # if RHS is an MlVec, otherwise performs pow element-wise using rhs as a scalar
    def __pow__ (self, rhs):
        if isinstance(rhs,MlVec):
            return self.dot(rhs)
        else:
            return self.map(lambda a,b: a ** b, rhs)

    # Equality Operator Overload
    def __eq__ (self,rhs):
        sum = self.fold(lambda x,y,z: z + (x == y), rhs)
        return sum == self.dim

    def __ne__ (self,rhs):
        return not (self == rhs)

# Testing Functions
a = MlVec([1,1,1,1])
b = MlVec([2,3,4,5])
test = a + b
assert(test == MlVec([3,4,5,6]))

test = a * 2
assert(test == MlVec([2,2,2,2]))

test_num = (a * 2) ** (a * 2)
assert(test_num == 16)

test = a * b + a * b
assert(test == MlVec([4,6,8,10]))

test = a - a
assert(test == MlVec([0,0,0,0]))

test = b / 2
assert(test == MlVec([1,1.5,2,2.5]))

test = b / b
assert(test == a)
print("Tests Passed")
