# Algebraic types

We want to model algebraic structures as flexible types.  This is a problem of polymorphism.

```haskell
data Semigroup a * where
introSemigroup : (*:a->a->a) 
		-> ((x,y,z:a)->(x*y)*z=x*(y*z)) 
		   -> Semigroup a *
```

```haskell
f
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjAyOTMxMDMwLC02MjMwNzU3NzhdfQ==
-->