join type MyMods :  ModMatTupElt, ModMatFldElt;
// behavior: expands to two 

AttachSpec( "Generic.Spec" );

declare type Frame;
declare type TheNillFrame : Frame;
__the_nill_frame := New(TheNillFrame);

declare type ListFrame : Frame;
declare attribute ListFrame: head, tail;

intrinsic NillFrame() -> TheNillFrame
{}
    return __the_nill_frame;
end intrinsic;

intrinsic Add(f::ListFrame, U::MyMods ) -> Frame
{}
    f2 := New(Frame);
    f2`head := U;
    f2`tail := f;
    return f;
end intrinsic;

intrinsic Head(f::ListFrame) -> MyMods
{}
    return f`head;
end intrinsic;
