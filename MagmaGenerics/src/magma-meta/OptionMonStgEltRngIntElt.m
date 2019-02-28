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

declare type OptionMonStgElt : OptionAny;
//declare type OptionMonStgElt : OptionAny;
declare type SomeMonStgElt : OptionMonStgElt;
declare attributes SomeMonStgElt : __val;


intrinsic Unapply(s::SomeMonStgElt) -> MonStgElt
{Unapply to extract the value of some.}
    return s`__val;
end intrinsic;

intrinsic Print(a::SomeMonStgElt) 
{}
    print(Unapply(a));
end intrinsic;

intrinsic Some(a::MonStgElt) -> SomeMonStgElt 
{}
    op := New( SomeMonStgElt );
    op`__val := a;
    return op;
end intrinsic;

intrinsic Unit(a::MonStgElt) -> OptionMonStgElt 
{}
    return Some(a);
end intrinsic;

/*
intrinsic map(a::OptionMonStgElt,f::MonStgElt=>$B$) -> Option$B$
{}
    if ISA(a,NoneMonStgElt) then 
        return New( None$B$ );
    else
        sb := New(Option$B$);
        sb`__val := Unapply(a) @ f;
        return sb;
    end if;
end intrinsic;

intrinsic join(a:Option$Option$A) -> OptionMonStgElt
{}
    if ISA(a,None$Option$) then 
        return New( NoneMonStgElt );
    else
        return Unapply(a);
    end if;
end intrinsic;
*/
