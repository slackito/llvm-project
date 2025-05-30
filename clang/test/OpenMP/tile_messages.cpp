// RUN: %clang_cc1 -triple x86_64-pc-linux-gnu -std=c++17 -fopenmp -fsyntax-only -Wuninitialized -verify %s

void func() {

  // expected-error@+1 {{expected '('}}
  #pragma omp tile sizes
    ;

  // expected-error@+2 {{expected expression}}
  // expected-error@+1 {{expected ')'}} expected-note@+1 {{to match this '('}}
  #pragma omp tile  sizes(
    ;

  // expected-error@+1 {{expected expression}}
  #pragma omp tile sizes()
    ;

  // expected-error@+1 {{expected ')'}} expected-note@+1 {{to match this '('}}
  #pragma omp tile sizes(5
    for (int i = 0; i < 7; ++i);

  // expected-error@+2 {{expected expression}}
  // expected-error@+1 {{expected ')'}} expected-note@+1 {{to match this '('}}
  #pragma omp tile sizes(5,
    ;

  // expected-error@+1 {{expected expression}}
  #pragma omp tile sizes(5,)
    ;

  // expected-error@+2 {{expected expression}}
  // expected-error@+1 {{expected ')'}} expected-note@+1 {{to match this '('}}
  #pragma omp tile sizes(5+
    ;

  // expected-error@+1 {{expected expression}}
  #pragma omp tile sizes(5+)
    ;

  // expected-error@+1 {{expected expression}}
  #pragma omp tile sizes(for)
    ;

  // expected-error@+1 {{argument to 'sizes' clause must be a strictly positive integer value}}
  #pragma omp tile sizes(0)
  for (int i = 0; i < 7; ++i)
    ;

  // expected-warning@+2 {{extra tokens at the end of '#pragma omp tile' are ignored}}
  // expected-error@+1 {{directive '#pragma omp tile' requires the 'sizes' clause}}
  #pragma omp tile foo
    ;

  // expected-error@+1 {{directive '#pragma omp tile' cannot contain more than one 'sizes' clause}}
  #pragma omp tile sizes(5) sizes(5)
  for (int i = 0; i < 7; ++i)
    ;

  // expected-error@+1 {{unexpected OpenMP clause 'collapse' in directive '#pragma omp tile'}}
  #pragma omp tile sizes(5) collapse(2)
  for (int i = 0; i < 7; ++i)
    ;

  {
    // expected-error@+2 {{expected statement}}
    #pragma omp tile sizes(5)
  }

  // expected-error@+2 {{statement after '#pragma omp tile' must be a for loop}}
  #pragma omp tile sizes(5)
  int b = 0;

  // expected-error@+3 {{statement after '#pragma omp tile' must be a for loop}}
  #pragma omp tile sizes(5,5)
  for (int i = 0; i < 7; ++i)
    ;

  // expected-error@+2 {{statement after '#pragma omp tile' must be a for loop}}
  #pragma omp tile sizes(5,5)
  for (int i = 0; i < 7; ++i) {
    int k = 3;
    for (int j = 0; j < 7; ++j)
      ;
  }

  // expected-error@+3 {{expected loop invariant expression}}
  #pragma omp tile sizes(5,5)
  for (int i = 0; i < 7; ++i)
    for (int j = i; j < 7; ++j)
      ;

  // expected-error@+3 {{expected loop invariant expression}}
  #pragma omp tile sizes(5,5)
  for (int i = 0; i < 7; ++i)
    for (int j = 0; j < i; ++j)
      ;

  // expected-error@+3 {{expected loop invariant expression}}
  #pragma omp tile sizes(5,5)
  for (int i = 0; i < 7; ++i)
    for (int j = 0; j < i; ++j)
      ;

  // expected-error@+5 {{expected 3 for loops after '#pragma omp for', but found only 2}}
  // expected-note@+1 {{as specified in 'collapse' clause}}
  #pragma omp for collapse(3)
  #pragma omp tile sizes(5)
  for (int i = 0; i < 7; ++i)
    ;

  // expected-error@+2 {{statement after '#pragma omp tile' must be a for loop}}
  #pragma omp tile sizes(5)
  #pragma omp for
  for (int i = 0; i < 7; ++i)
    ;

  // expected-error@+2 {{condition of OpenMP for loop must be a relational comparison ('<', '<=', '>', '>=', or '!=') of loop variable 'i'}}
  #pragma omp tile sizes(5)
  for (int i = 0; i/3<7; ++i)
    ;

  // expected-error@+2 {{expression must have integral or unscoped enumeration type, not 'struct S'}}
  struct S{} s;
  #pragma omp tile sizes(s)
  for (int i = 0; i < 7; ++i)
    ;
}


template <typename T>
static void templated_func() {
  // In a template context, but expression itself not instantiation-dependent

  // expected-error@+1 {{argument to 'sizes' clause must be a strictly positive integer value}}
  #pragma omp tile sizes(0)
  for (int i = 0; i < 7; ++i)
    ;
}

template <int S>
static void templated_func_value_dependent() {
  // expected-error@+1 {{argument to 'sizes' clause must be a strictly positive integer value}}
  #pragma omp tile sizes(S)
  for (int i = 0; i < 7; ++i)
    ;
}

template <typename T>
static void templated_func_type_dependent() {
  constexpr T s = 0;
  // expected-error@+1 {{argument to 'sizes' clause must be a strictly positive integer value}}
  #pragma omp tile sizes(s)
  for (int i = 0; i < 7; ++i)
    ;
}

void template_inst() {
  templated_func<int>();
  // expected-note@+1 {{in instantiation of function template specialization 'templated_func_value_dependent<0>' requested here}}
  templated_func_value_dependent<0>();
  // expected-note@+1 {{in instantiation of function template specialization 'templated_func_type_dependent<int>' requested here}}
  templated_func_type_dependent<int>();
}

namespace GH139073 {
void f(void) {
  // Clang would previously crash on this because of the invalid DeclRefExpr.
#pragma omp tile sizes(a) // expected-error {{use of undeclared identifier 'a'}}
  for (int i = 0; i < 10; i++)
    ;
}
} // namespace GH139073
