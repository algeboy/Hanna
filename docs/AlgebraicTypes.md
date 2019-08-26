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

What I would like is a type that lets me check that an existing type contains something I want.  Something like `a:List Nat where 1 in a`.  A weak example would be that `a` start with $1$.  So `(1::a) : List Nat` so whatever `a` is will have to build up with `1::_` to get to `List Nat`.  If I want `1` anywhere I would need a `Set` type.

The specific type introduction is what?
$$
\frac{a:Set, b:Set, a\subset b}{\Gamma\vdash super}(\ I)
$$
<!--stackedit_data:
eyJoaXN0b3J5IjpbODA5ODY4Nzc0LDg3NDYyNTU3MCwtNjIzMD
c1Nzc4XX0=
-->