// MACHINE GENERATED CODE: EDITS WILL BE OVERWRITTEN


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

declare type OptionRngIntElt : OptionAny;
//declare type OptionRngIntElt : OptionAny;
declare type SomeRngIntElt : OptionRngIntElt;
declare attributes SomeRngIntElt : __val;


intrinsic Unapply(s::SomeRngIntElt) -> RngIntElt
{Unapply to extract the value of some.}
    return s`__val;
end intrinsic;

intrinsic Print(a::SomeRngIntElt) 
{}
    print(Unapply(a));
end intrinsic;

intrinsic Some(a::RngIntElt) -> SomeRngIntElt 
{}
    op := New( SomeRngIntElt );
    op`__val := a;
    return op;
end intrinsic;

intrinsic Unit(a::RngIntElt) -> OptionRngIntElt 
{}
    return Some(a);
end intrinsic;

/*
intrinsic map(a::OptionRngIntElt,f::RngIntElt=>$B$) -> Option$B$
{}
    if ISA(a,NoneRngIntElt) then 
        return New( None$B$ );
    else
        sb := New(Option$B$);
        sb`__val := Unapply(a) @ f;
        return sb;
    end if;
end intrinsic;

intrinsic join(a:Option$Option$A) -> OptionRngIntElt
{}
    if ISA(a,None$Option$) then 
        return New( NoneRngIntElt );
    else
        return Unapply(a);
    end if;
end intrinsic;
*/
