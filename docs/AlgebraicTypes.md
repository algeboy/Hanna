# Algebraic types

We want to model algebraic structures as flexible types.  This is a problem of polymorphism.

```haskell
data Semigroup a * where
introSemigroup : (*:a->a->a) 
		-> ((x,y,z:a)->(x*y)*z=x*(y*z)) 
		   -> Semigroup a *
```


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzE0MDAzMTA0LC02MjMwNzU3NzhdfQ==
-->