
declare type Functor$O$A$;
declare attributes Functor : __apply, __map;

intrinsic '@'(
    x::%A%,       // The object
    F::Functor) -> $A$
{Apply _F_ to object/vertex _x_.}
    return F`__apply(x);
end intrinsic;

intrinsic '@'(
    x::$A$,       // The object
    F::Functor) -> $A$
{Apply _F_ to object/vertex _x_.}
    return F`__apply(x);
end intrinsic;
