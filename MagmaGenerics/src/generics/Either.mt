declare template Either$A,B$;

// Left ========================================================
declare type Left$A$ : Either$A,B$;

intrinsic Unit(a::$A$) -> Left$A$ 
{}
    left := New( Left$A$ );
    left`__val := a;
    return left;
end intrinsic;

intrinsic Left(a::$A$) -> Left$A$ 
{}
    return Unit(a);
end intrinsic;

intrinsic Unapply(s::Left$A$) -> $A$
{Unapply to extract the value of left.}
    return s`__val;
end intrinsic;

intrinsic Sprint(a::Left$A$) -> MonStgElt
{}
    return Sprint(Unapply(a));
end intrinsic;

intrinsic Print(a::Left$A$)
{}
    print(Sprint(a));
end intrinsic;

// RIGHT =================================================
declare type Right$B$ : Either$A,B$;

intrinsic Unit(b::$B$) -> Right$B$ 
{}
    r := New( Right$B$ );
    r`__val := b;
    return r;
end intrinsic;

intrinsic Right(b::$B$) -> Right$B$ 
{}
    return Unit(b);
end intrinsic;

intrinsic Unapply(s::Right$B$) -> $B$
{Unapply to extract the value of right.}
    return s`__val;
end intrinsic;

intrinsic Sprint(b::Right$B$) -> MonStgElt
{}
    return Sprint(Unapply(b));
end intrinsic;

intrinsic Print(b::Right$B$)
{}
    print(Sprint(b));
end intrinsic;
