
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

declare template Option$A$ : OptionAny;
//declare type Option$A$ : OptionAny;
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