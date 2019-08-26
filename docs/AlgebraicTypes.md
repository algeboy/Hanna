# Algebraic types

We want to model algebraic structures as flexible types.  This is a problem of polymorphism.

```haskell
data Semigroup a * where
introSemigroup : (*:a->a->a) 
		-> ((x,y,z:a)->(x*y)*z=x*(y*z)) 
		   -> Semigroup a *
```

```haskell
data Algebraic a:type ops:(Vect (Op a) n) laws:List Eq a ops

groupFun : (ops:List Op a) -> ({*,-,1} <: ops) -> (asc<:laws) ...
```

What I would like is a type that lets me check that an existing type contains something I want.  Something like `a:List Nat where 1 in a`.  A weak example would be that `a` start with $1$.  So `(1::a) : List Nat 
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTE1NDU5MjA4MSwtNjIzMDc1Nzc4XX0=
-->