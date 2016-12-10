#include "nvec.h"
#include <iostream>
#include <cassert>

using namespace std;
using namespace ML;

/* Testing Functions */
int main() {
  // Use Variadic Constructor!
  MlVecD a(1.0,1.0,1.0,1.0);

  // Or use Initialize List!
  MlVecD b = { 2.0, 3.0, 4.0, 5.0 };

  assert(a == a && b == b);
  assert(a != b && b != a);

  auto c = a + b;
  assert(c == MlVecD(3.0,4.0,5.0,6.0));

  c = b - a;
  assert(c == MlVecD(1.0,2.0,3.0,4.0));

  c = b * b;
  assert(c == MlVecD(4.0,9.0,16.0,25.0));

  assert(a * 2 == 2 * a && a * 2 ==  MlVecD(2.0,2.0,2.0,2.0));

  c = b / b;
  assert(c == MlVecD(1.0,1.0,1.0,1.0));

  c = a / 2;
  assert(a / 2 == a * (1.0 / 2.0) && a / 2 == MlVecD(0.5,0.5,0.5,0.5));
  assert(a / 2 == a / MlVecD(2.0,2.0,2.0,2.0));

  assert(a * b == b * a && a * b == MlVecD(2.0,3.0,4.0,5.0));

  c = a * b + b * a;
  assert(c.dot(c) == 216.0);

  c = a.dot(b);
  assert(c == 14.0);

  cout << "Tests Passed" << endl;
  return 0;
}
