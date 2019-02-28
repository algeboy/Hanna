# Hanna: Generics and Higher-kinded types

We want to support higher kinded types in Hanna so that we can build functors.  Below is our approach.

## Generics

Generics concern construction of new types but ones where at the time of writing the program we do not have all the details about the types on which we depend.  Therefore we leave in place variables for these types.  Our generic type constructor is as always `trait`.

Consider the archetype for generics: a list of terms of fixed but unknown type `A`.
```
trait List[A]
trait Nill extends List[Any]
trait Cons[A](head:A,tail:List[A]) extends List[A]
```
