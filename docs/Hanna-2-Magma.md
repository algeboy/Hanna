# Planned patterns
CC-BY-2019 James B. Wilson



## Primitive matching


| Hanna  | Magma         |
| ------ | ------------- |
| Int    | RngIntElt     |
| BigInt | ??            |
| Float  | ??            |
| Double | ??            |
| String | MonStgElt     |
| =      | eq            |
| >      | gt            |
| >=     | ge            |
| ><     | ne            |
| <      | lt            |
| <=     | le            |

## Quick function builders

```
/** Find the sign of the integer. */
def sign(x:Int):Int = if x >= 0 then 1 else -1
```
Compiles to
```
// CAUTION===========================
// THIS IS MACHINE GENERATED CODE
// EDITING HERE MAY BE OVERWRITTEN
// EDIT ORIGINAL HANNA CODE INSTEAD
intrinsic sign(x::RngIntElt) -> RngIntElt
{Find the square.}
  if x gt 0 then
    squareRet1234 := 1;
  else
    squareRet1234 := -1;
  end if;
  return squareRet1234;
end intrinsic;
//END MACHINE EDIT=================
```



## Support for native functions

```
import hanna.magma.types.*

def Order(G:Group[MAGMA]):Int =
  extern "MAGMA" {
    return LMGOrder(G);
  }
```
Expands to
```
// CAUTION===========================
...
intrinsid Order(G::HannaGroup) -> RngIntElt
{}
  G_native := Unapply(G);
  orderRet87A0 := LMGOrder(G_native);
  return orderRet87A0;
end intrinsic;
//END MACHINE EDIT=================
```



## Quick type builders

```
class CoordinateTensorSpace(K:Ring, dims:List[Nat])
```
expands to
```
// ...
declare type CoordinateTensorSpaceType;
declare attributes CoorinateTensorSpaceType : K, dims;

intrinsic CoordinateTensorSpace(
  K::HannaRng,
  dims::ListNat
) -> CoordinateTensorSpaceType
{Instantiates a CoordinateTensorSpace}
  this45F1 := New(CoordinateTensorSpace);
  this45F1`K := K;
  this45F1`dims := dims;
  return this45F1;
end intrinsic;
// ...
```
Usage 
```
TS = new CoordinateTensorSpace(GF(5), [3,3,2])
```
Becomes
```
TS := CoordinateTensorSpace(GF(5), [3,3,2] );
```

Method with classes are passed a `this` pointer.

### Generic hierarchies

## Pattern matching

```
case class Some[A](a:A)
```
along with introducing the type as described above also creates the following two methods (uses template in this example).
```
intrinsic Apply(
  a::$A$
) -> Some$A$
{Constructs Some type for pattern matching.}
  return Some(a);
end intrinsic;
intrinsic Unapply(
  this::Some$A$
) -> $A$
{Deconstructs Some type for pattern matching.}
  return this`a;
end intrinsic;
```
Usage
```
def map(x:Option[A])(f:A->B):Option[B] =
  match x -> {
    case Some(a) -> Some(f(a))
    case None[A]() -> None[B]()
  }
```
Results in
```
intrinsic map(
  x::Option$A$,
  f::Function$A,B$,
) -> Option$B$
{}
  case Type(x) :
    when Some$A$ : 
      a := Unapply(x);
      someReturn1234 := Some(f(a));
      return someReturn1234;
    when None$A$ :
      someReturn1234 := None$B$();
      return someReturn1234;
      
  end case;
end intrinsic;
```

### For comprehensions

TBD