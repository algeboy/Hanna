# Templates for Magma

CC-BY 2019 James B. Wilson

This is proposal for support of a template for the Magma programming language. Along with direct application is it also planned as an intermediate step in the creation of generics.

## Template Syntax

Magma templates are an enrichment to the Magma language and thus template code can appear with any amount of regular Magma code.

Added to the language is the command:
```
declare template <A>;
```
When discovered this permits all uses of `$A$` to be replace with a suitable string when evaluating the template.  Consider the following example.

```
declare template A;
declare type Some$A$;
declare attributes Some$A$ : __val;

intrinsic Some(a::$A$) -> Some$A$ 
{Make Some(a).}
    some := New( Some$A$ );
    some`__val := a;
    return some;
end intrinsic;

intrinsic Unapply(some::Some$A$) -> $A$
{Unapply to extract the value of some.}
    return some`__val;
end intrinsic;
```
We save this template in a file, by convention `<filename>.mt`, so here we have `<path>/Some.mt`. 

Note that the use of `$` elsewhere in magma is singular, e.g. 
```
>Order(Sym({0..10}));
>ord := $1;
```
This is only used in command-line interactions.  Meanwhile templates cannot be directly used at the command line and so these two uses of of `$` will not collide. Still, the use of $A$ within strings, e.g. `x := "We used $A$";`, must be exempted from substitution of the template variable.

To evaluate the template we do as follows.  Assume first to have attached the `Template.Spec`
```
AttachSpec( "Generic.Spec" );
```
Load the generic template with the following command `NewTemplate.
```
Some := NewTemplate( "<path>/Some.mt" );
```
To create a specific instance use the command `EvaluateTemplate`.
```
EvaluateTemplate( Some, RngIntElt );
EvaluateTemplate( Some, MonStgElt );
```
This results in creating two new types inside Magma's type system, the first called `SomeRngIntElt` the other `SomeMonStgElt`.  Both types also come with their own intrinsics but with the same name.
```
> someNumber := Some( 5 );
> someString := Some( "five" );
> Type(Unapply(someNumber));
RngIntElt
> Type(Unapply(someString));
MonStgElt
```


To use this template we create must replace the value of `A` with a type, that is a term of Magma type `Cat`.

```
declare type ListAny;
declare type Nill : ListAny;

declare template $A$;
declare type List$A$ : ListAny;

declare 

declare 
```

```
Option
A

declare type OptionAny;
declare type NoneType : OptionAny;
__the_none := New(NoneType);

intrinsic Print(a::NoneType)
{}
    print("None");
end intrinsic;

intrinsic None() -> NoneType
{}
    return __the_none;
end intrinsic;

intrinsic 'eq'(x::NoneType, y::NoneType) -> BoolElt
{}
    return true;
end intrinsic;

declare type Option$A$ : OptionAny;
declare type Some$A$ : Option$A$;
declare attributes Some$A$ : __val;


intrinsic Unapply(s::Some$A$) -> $A$
{Unapply to extract the value of some.}
    return s`__val;
end intrinsic;

intrinsic Print(a::Some$A$) 
{}
    print(Unapply(a));
end intrinsic;

intrinsic Some(a::$A$) -> Some$A$ 
{}
    op := New( Some$A$ );
    op`__val := a;
    return op;
end intrinsic;

intrinsic Unit(a::$A$) -> Option$A$ 
{}
    return Some(a);
end intrinsic;

/*
intrinsic map(a::Option$A$,f::$A$=>$B$) -> Option$B$
{}
    if ISA(a,None$A$) then 
        return New( None$B$ );
    else
        sb := New(Option$B$);
        sb`__val := Unapply(a) @ f;
        return sb;
    end if;
end intrinsic;

intrinsic join(a:Option$Option$A$$) -> Option$A$
{}
    if ISA(a,None$Option$A$) then 
        return New( None$A$ );
    else
        return Unapply(a);
    end if;
end intrinsic;
*/
```