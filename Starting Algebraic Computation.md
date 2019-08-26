## Operators and Algebraic Systems

The literature, blogs, and podcasts on functional programming are embracing paradigms of design that at least sound like mathematics and especially consider abstractions in algebra and category theory.  

encouraging paradigms of design where data structures routines are distilled into simple abstractions which must satisfy algebraic equations.  For example, that instead of a `List` being an array 

 the advice on programblogs the theory of **algebra of package** has emerged.  Here designers create routines that have simple signatures that when composed lead to equations, known as **laws**, which the package claims will hold.  None is more popular than the laws of a **monad**., but we are concerned with something simpler.

There are detailed examples and proofs that the examples satisfy the laws.  But when it comes to the software itself, the compiler is not checking the monad laws.


The following article is based on a by-product of a joint work with Heiko Dietrich of Monash University in Melbourne available at [arXiv:1806.08872](https://arxiv.org/abs/1806.08872). The main theme there is to decide if to algebraic structures are the same (isomorphic).  Evidently that requires a means to perform computations within algebraic structure.  

The problem we discovered is one known to many.  The obvious ways to make data structures for mathematical computations are to list all the properties we assert are true but in general we cannot prevent someone from creating an input that claims to be an adequate algebraic system but in truth is flawed.

Our solution to this problem?
>Every algebraic structure input for computation should include proofs of axioms they claim of their operations.

In what follows we detail how this can be done while remaining practical and user friendly.  Indeed, the added investment pays off with new strengths.

---



We take the view that algebra concerns first and foremost types equipped with operations, e.g. `*,+,-,^-,1,0,/,\,[...]`.  For sets we can use a type such as `Set[A]` where `A` parameterizes an arbitrary type.  For instance
`Set[Int]`, `Set[Matrix[_]]`, and `Set[Perm[_]]` will e natural candidates for sets.

An **operation** in mathematical terms means simply a function `f:(A,...,A)=>A`, e.g. `+:(A,A)=>A`, `-:A=>A`, and `id:()=>A`.  There is a subtle point that an operation need not be defined on all inputs of type `A`.  So in code an operation can be a _partial function_, i.e. `f:Seq[A]=>Option[A]` will be the general signature of an operation some object of type `Set[A]`.  To record the arity (valence) of `f` we include a further integer parameter `vav`.
```scala
class Operator[+A](val vav:Int,val op:Seq[A]=>Option[A])
val +_5 = new Operator[Int](2,(x:Int,y:Int)=>x+y % 5)  // Addition modulo 5.
val ^-_5 = new Operator[Int](1,(x:Int)=>if(x%5==0) None else Some(my_mod_inv(x)))
```
For more on syntax see notes below.
The example `^-_5` is a partial function recognizing that multiples of 5 are not invertible mod 5.  Several helper functions smooth over bulky notation when creating common binary, unary, and nullary operators.

Now by an **algebraic structure** we gather together operators on a common set.
```scala
class AlgeStruct[A](val dom:Set[A],ops:List[Operator[A]])
```
This is not yet the entire definition of an algebraic structure, later we shall add laws.  

## Removing Low-order classes.

We saw one limitation in straight-forward object-oriented design of algebraic systems, e.g. groups, rings, monoids, semi-groups, etc. is [low order types](Low-order-types-in-CAS) problem.  In particular to resolve the many similarly named function calls we have to create several new helper types to describe the appropriate inputs to each operation.  That lead to creating multiple data types describing essentially identical state, e.g. an integer described as `GrpElt`,
as well as `RngElt`, or `Matrix` and so on.

The functional approach sees the underlying domain as independent from the operations and operations are simply functions on the set.  So there is not need to create these auxiliary low-order types.
Notice that such a treatment of algebraic structures can only be achieved in a functional programming language since the essential state is functions.

Of course, there is value in subtyping for convenience.  For example we can make something group-like to aid in the creation of groups.
```scala
case class GroupLike[A](val dom:Set[A],op2:(A,A)=>Option[A],op1:A=>Option[A],op0:A) 
  extends AlgeStruct[A](dom,List(BinaryOp(op2),UnaryOp(op1),NullaryOp(op0)))
val C5 = new GroupLike(
  Set(0,1,2,3,4),
  (x:Int,y:Int)=>Some(x+y % 5)),
  (x:Int)=> Some(-x % 5),
   0
)
C5.ops(0)(2,3) == C5.ops(2)  // tests 2+3 = 0 (mod 5), but in terrible syntax 
```
The price we have paid is in syntax for operations.  In a later section we will
demonstrate how the Scala syntax allows some yoga (thanks in part to themaset on 
StackExchange) that conveniently adapts that
obtuse notation into something more memorable like the following
```scala
var ~ = C5.congruence; var +_5 = C5.prod
(2+7) ~ (4+15)
2+_5 7 == 4 +_5 15
```
So the syntax can be fixed.  It is also the long term goal of Hanna to introduce a REPL with further syntactic convenience.

## Resolving Evolving Polymorphism.

Our approach resolves the problem of [evolving polymorphism](Evolving-Polymorphism) by treating the
operations as state (data) rather than as functions on a class.  For example,
to move a group element of `C5` into a ring `Z5` we simply append a new binary operation, and
to make `C5` into an additive monoid `M5` we remove an operation.  To facilitate this we
modestly adapt operators to include names.

```scala
class Operator[+A](val vav:Int,val op:Seq[A]=>Option[A])(val symb:String)
...
case class GroupLike[A](val dom:Set[A],op2:(A,A)=>Option[A],op1:A=>Option[A],op0:A) 
  extends AlgeStruct[A](...)

val C5 = new GroupLike(
  Set(0,1,2,3,4),
  (x:Int,y:Int)=>Some(x+y % 5)),
  (x:Int)=> Some(-x % 5),
   0
)
val Z5 = C5.resymb(List("+","-","0")) + BinaryOp((x:Int,y:Int)=>x*y%5))("*")
val M5 = C5 - "^-"  // drop the operation "^-".
```
The addition of symbols to operators will later allow us to perform the satisfaction testing,
that is to test if an algebraic structure satisfies a set of laws such associativity.
In this way the concept of a group can be more strongly supported computationally than as
is done presently by simply declare a type with the approriate name.

In short, algebraic structures a somewhat specialized containers, similar to lists and arrays, to which we can add and removed operations as the needs arise.

***
Notes.
 
* The concept of an `Option[X]` is that we assume the return type is `X` unless 
the given input is not in the domain of the function, and then the return is constant type `None`.
In this way we need not be concerned with having a physical set `S` on which to define the functions
which might not be reasonable.  For example, the inverse on the set of invertible 10 x 10 matrices
can be defined as calculating the inverse of an arbitrary 10 x 10 matrix and if it fails return `None`,
an indication to the user of mistaken input.  Meanwhile listing the more than 2^100 (10 x 10)-matrices over
any ring is completely unnecessary.
* By `Set[A]` we 
mean some class A defines a type and `Set[A]` is the theoretical set {x: x is an instance of A }.
E.g. `Set[Int]={-2^32-1,...,2^32}` and while we don't typically enumerate this set it is usually
helpful to have a test for membership.  
* Last, we use the Scala style syntax of `=>` for functions in place of the mathematical `->`.
Implications are not a notation used in Scala so there will be no chance for confusion.






> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbNzI3MzMxNDIxXX0=
-->