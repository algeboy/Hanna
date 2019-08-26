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

groupFun : (ops:List Op a) -> (G:Algebraic a ops laws) -> 


```
<!--stackedit_data:
eyJoaXN0b3J5IjpbNDkyMzk5NzIsLTYyMzA3NTc3OF19
-->