#ifndef __MlVec_h__
#define __MlVec_h__

#include <vector>
#include <math.h>
#include <functional>
#include <iostream>

using namespace std;

namespace ML {

    /* Type Definitions */
    template <class U>
    using Fn1 = function<U(U)>;

    template <class U>
    using Fn2 = function<U(U,U)>;

    template <class U>
    using Fn3 = function<U(U,U,U)>;

    /* Vec Functions used for Variadic Template type resolution */
    template <typename U>
    vector<U> vec(U num) {
      vector<U> v;
      v.push_back(num);
      return v;
    }

    template <typename U, typename... Us>
    vector<U> vec(U first, Us... rest) {
      vector<U> v;
      auto r = vec<U>(rest...);
      v.push_back(first);
      v.insert(v.end(), r.begin(), r.end());
      return v;
    }

    /* Machine Learning Vector Type */
    template <class T>
    class MlVec {
      /* Declare a Self type for use throughout the class to
         simplify function signatures. */
      using Self = MlVec<T>;

    public:
      /* Constructors */
      MlVec() { }

      template <typename... Ts>
      MlVec(Ts... t) {
        vector<T> d = vec(t...);
        dim = d.size();
        data = d;
      }

      MlVec(size_t size):dim(size) {
        data = vector<T>(size);
      }

      MlVec(const vector<T> &d) {
        data = d;
        dim = d.size();
      }

      MlVec(const MlVec<T> &d) {
          data = d.data;
          dim = d.dim;
      }

      MlVec(T* d, size_t size) {
        data = vector<T>(size);
        memcpy(data, d, size * sizeof(T));
        dim = size;
      }

      /* Higher Order Functions */
      Self map(const Fn1<T>& fn)const {
        Self ans(dim);
        for(size_t i = 0; i < dim; i++)
          ans[i] = fn(data[i]);
        return ans;
      }

      Self map(const Self &rhs, const Fn2<T>& fn)const {
        Self ans(dim);
        for(size_t i = 0; i < dim; i++)
          ans[i] = fn(data[i],rhs[i]);
        return ans;
      }

      T fold(const Fn2<T>& fn, T accum)const {
        for(size_t i = 0; i < dim; i++)
          accum = fn(data[i],accum);
        return accum;
      }

      T fold(const Self &rhs, const Fn3<T>& fn, T accum)const {
        for(size_t i = 0; i < dim; i++)
          accum = fn(data[i],rhs[i],accum);
        return accum;
      }

      /* Array Operator Overload Functions */
      const T& operator[](const size_t index)const {
        return data[index];
      }

      T& operator[](const size_t index) {
        return data[index];
      }

      /* Vector Math Functions implemented using Higher Order functions */
      Self add(const Self &rhs)const {
        return map(rhs, [&](T a, T b) { return a + b; });
      }

      Self add(const T rhs)const {
        return map([&](T a) { return a + rhs; });
      }

      Self sub(const Self &rhs)const {
        return map(rhs, [&](T a, T b) { return a - b; });
      }

      Self mul(const Self &rhs)const {
        return map(rhs, [&](T a, T b) { return a * b; });
      }

      Self mul(const T rhs)const {
        return map([&](T a) { return a * rhs; });
      }

      Self div(const Self &rhs)const {
        return map(rhs, [&](T a, T b) { return a / b; });
      }

      T dot(const Self &rhs)const {
        return fold(rhs,
                    [&](T a, T b, T c) { return c + a * b; },
                    static_cast<T>(0));
      }

      /* Opeator Overload Functions */
      Self operator+(const Self &o) { return add(o); }
      Self operator-(const Self &o) { return sub(o); }
      Self operator*(const Self &o) { return mul(o); }
      Self operator/(const Self &o) { return div(o); }
      Self operator*(const T o) { return mul(o); }
      Self operator/(const T o) { return mul(1.0 / o); }
      Self operator+(const T o) { return add(o); }
      Self operator-(const T o) { return add(0 - o); }

      Self& operator=(const Self &o) {
        data = o.data;
        dim = o.dim;
        return *this;
      }

      bool operator==(const Self &o) {
        return dim == o.dim && dim == (size_t)fold(o,[&](T a, T b, T c)
          { return c + static_cast<T>(a == b ? 1: 0); },
          static_cast<T>(0));
      }

      bool operator!=(const Self &o) { return !(*this == o); }

    private:
      vector<T> data;
      size_t dim;
    };

    /* Scalar Multiply overload for LHS scalar */
    template <class U>
    MlVec<U> operator*(U l, MlVec<U> &r) {
      return r.mul(l);
    }

    /* Scalar Multiply overload for LHS scalar */
    template <class U, class V>
    MlVec<U> operator*(V l, MlVec<U> &r) {
      return r.mul(l);
    }

    using MlVecF = MlVec<float>;
    using MlVecD = MlVec<double>;
}
#endif