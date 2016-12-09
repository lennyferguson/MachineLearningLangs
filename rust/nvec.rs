use std::ops::{Add,Sub,Mul,Div,Index,IndexMut};

#[derive(Clone,PartialEq)]
struct MlVec {
    data : Vec<f64>
}

/* Rust Vector implemented without Generics
   Ideally, I would like to allow for MlVectors that support f32 and f16 */
impl MlVec {
    fn new(v:Vec<f64>) -> Self { MlVec{ data:v } }

    fn len(&self) -> usize { self.data.len() }

    // Higher Order Functions
    fn fold<F:Fn(f64,f64)->f64>(&self, f: F, mut accum:f64) -> f64  {
        for i in 0..self.len() {
            accum = f(self.data[i], accum);
        }
        accum
    }

    fn fold2<F:Fn(f64,f64,f64)->f64> (&self, rhs:&Self, f:F, mut accum:f64) -> f64 {
        for i in 0..self.len() {
            accum = f(self.data[i],rhs[i], accum);
        }
        accum
    }

    fn map<F:Fn(f64)->f64> (&self,f:F) -> Self {
        let mut ans = MlVec{ data : vec![0f64;self.len()] };
        for i in 0..self.len() {
            ans[i] = f(self.data[i])
        }
        ans
    }

    fn map2<F:Fn(f64,f64)->f64> (&self, rhs:&Self, f:F) -> Self {
        let mut ans = MlVec{ data: vec![0f64;self.len()] };
        for i in 0..self.len() {
            ans[i] = f(self.data[i],rhs[i])
        }
        ans
    }

    // Arithmatic Operations
    fn add(&self,rhs:&Self) -> Self {
        self.map2(rhs, |a,b| { a + b } )
    }

    fn sub(&self,rhs:&Self) -> Self {
        self.map2(rhs, |a,b| { a - b })
    }

    fn mul(&self,rhs:&Self) -> Self {
        self.map2(rhs, |a,b| { a * b })
    }

    fn scalar_mult(&self, rhs:f64) -> Self {
        self.map(|a| { a * rhs })
    }

    fn scalar_add(&self, rhs:f64) -> Self {
        self.map(|a| { a + rhs })
    }

    fn div(&self, rhs:&Self) -> Self {
        self.map2(rhs, |a,b| { a / b })
    }

    fn dot(&self,rhs:&Self) -> f64 {
        self.fold2(rhs, |a,b,c| { a * b + c }, 0.0f64)
    }
}

// Implement Traits
impl Index<usize> for MlVec {
    type Output = f64;
    fn index<'a>(&'a self, _index:usize) -> &'a f64 { & self.data[_index] }
}

impl IndexMut<usize> for MlVec {
    fn index_mut<'a>(&'a mut self, _index:usize) -> &'a mut f64 { & mut self.data[_index] }
}

impl<'a> Add<&'a MlVec> for &'a MlVec {
    type Output = MlVec;
    fn add(self,rhs: Self) -> MlVec { self.add(rhs) }
}

impl<'a> Add<f64> for &'a MlVec {
    type Output = MlVec;
    fn add(self,rhs:f64) -> MlVec { self.scalar_add(rhs) }
}

impl<'a> Sub<&'a MlVec> for &'a MlVec {
    type Output = MlVec;
    fn sub(self,rhs: Self) -> MlVec { self.sub(rhs) }
}

impl<'a> Sub<f64> for &'a MlVec {
    type Output = MlVec;
    fn sub(self,rhs:f64) -> MlVec { self.scalar_add(-rhs) }
}

impl<'a> Mul<&'a MlVec> for &'a MlVec {
    type Output = MlVec;
    fn mul(self,rhs: Self) -> MlVec { self.mul(rhs) }
}

impl<'a> Mul<f64> for &'a MlVec {
    type Output = MlVec;
    fn mul(self,rhs:f64) -> MlVec  { self.scalar_mult(rhs) }
}

impl<'a> Div<&'a MlVec> for &'a MlVec {
    type Output = MlVec;
    fn div(self,rhs: Self) -> MlVec { self.div(rhs) }
}

impl<'a> Div<f64> for &'a MlVec {
    type Output = MlVec;
    fn div(self,rhs:f64) -> MlVec { self.scalar_mult(1.0f64 / rhs) }
}

// Run Tests
fn main() {
    let v = MlVec::new(vec!(1.0,1.0,1.0));
    let u = MlVec::new(vec!(1.0,2.0,3.0));
    assert!(v == v);
    assert!(v != u);
    assert!(&v + &u == MlVec::new(vec!(2.0,3.0,4.0)));
    assert!(&v + &u == v.add(&u));
    assert!(&u - &v == MlVec::new(vec!(0.0,1.0,2.0)));
    assert!(&v * 2.0 == MlVec::new(vec!(2.0,2.0,2.0)));
    assert!(&u * &u == MlVec::new(vec!(1.0,4.0,9.0)));
    assert!(&u / &u == MlVec::new(vec!(1.0,1.0,1.0)));
    assert!(&v / 2.0 == MlVec::new(vec!(0.5,0.5,0.5)));
    assert!(v.dot(&v) == 3.0);
    assert!(v.dot(&(&v + 1.0)) == 6.0);
    assert!(&v - 1.0 == MlVec::new(vec!(0.0,0.0,0.0)));
    assert!(v.fold(|a,b| {a + b}, 0.0) == 3.0);
    
    /* Example of 'splitting' a MlVec using a function 
       using 2 different approaches. */
    let split = |val| {
        match val {
             0.0 ...  5.0 => 0.0,
             5.0 ... 10.0 => 1.0,
            10.0 ... 15.0 => 2.0,
            _             => 3.0,
        }
    };

    let bound = |a,b,c| {
        c > a && c < b
    };

    let a =  0.0;
    let b =  5.0;
    let c = 10.0;
    let d = 15.0;

    let split2 = move |val| {
        if      bound(a,b,val) {0.0}
        else if bound(b,c,val) {1.0}
        else if bound(c,d,val) {2.0}
        else                   {3.0} 
    };

    let r_a:Vec<f64> = vec!(0.0,  5.0, 10.0);
    let r_b:Vec<f64> = vec!(5.0, 10.0, 15.0);

    let split3 = move |val:f64| {
        let mut num = 0.0;
        for i in 0..r_a.len() {
            if val > r_a[i] && val < r_b[i] 
                { return num; }
            else 
                { num += 1.0; }
        }
        num
    };

    // In this example, we have a Vector with 'continuous' values
    // that we wish to discretize with a 'splitting' function. 
    let test = MlVec::new(vec!(27.24,14.1111,2.79,7.83,9.853));
    let expected = MlVec::new(vec!(3.0,2.0,0.0,1.0,1.0));
    assert!(test.map(split)  == expected);
    assert!(test.map(split2) == expected);
    assert!(test.map(split3) == expected);
    println!("Tests Passed!");
}