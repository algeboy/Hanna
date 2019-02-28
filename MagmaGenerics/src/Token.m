
declare type Tkn;

declare type OpenTkn : Tkn;
declare type LParen : OpenTkn;  // '('
declare type LBrace : OpenTkn;  // '{'
declare type LBrack : OpenTkn;  // '['

declare type ClosedTkn : Tkn;
declare type RParen : ClosedTkn;    // ')'
declare type RBrace : ClosedTkn;    // '}'
declare type RBrack : ClosedTkn;    // ']'


declare type InfixTkn : Tkn;
declare type TypeTkn : InfixTkn;     // :
declare type AssignTkn : InfixTkn;   // =
declare type FuncTkn : Tkn;          // ->
declare type TimesTkn : Tkn;         // *
declare type PlusTkn : Tkn;          // +
declare type MinusTkn : Tkn;         // -
declare type AndTkn : Tkn;          // &
declare type OrTkn : Tkn;          // |

declare type KeyTkn     : Tkn;
declare type TraitTkn   : KeyTkn;   // trait
declare type DefTkn     : KeyTkn;   // def
declare type IfTkn      : KeyTkn;   // if
declare type ThenTkn    : KeyTkn;   // then
declare type ElseTkn    : KeyTokn;  // else

declare type VarTkn     : Tkn;      // variable name.
declare attributes VarTkn : name;


intrinsic ToToken(seg:MonStrElt) -> Token
{String into token.}
    case seg :
        // Groupings
        when "(" : return New(LParen);
        when "{" : return New(LBrace);
        when "[" : return New(LBrack);
        when ")" : return New(RParen);
        when "}" : return New(RBrace);
        when "]" : return New(RBrack);

        // Infix ops
        when ":"    : return New(TypeTkn);
        when "="    : return New(AssignTkn);
        when "->"   : return New(FuncTkn);
        when "*"   : return New(TimesTkn);
        when "+"   : return New(PlusTkn);
        when "-"   : return New(MinusTkn);
        when "&"   : return New(AndTkn);
        when "|"   : return New(OrTkn);

        // Keywords
        when "def"      : return New(DefTkn);
        when "trait"    : return New(TraitTkn);
        when "if"       : return New(IfTkn);
        when "then"     : return New(ThenTkn);
        when "else"     : return New(ElseTkn);
    end case;
    newVar := New(VarTkn);
    newVar`name := seg;
    return newVar;
end intrinsic;

intrinsic Sprint(t::Tkn) -> MonStgElt
{} 
    return Sprint(Type(t));
end intrinsic;

intrinsic Sprint(t::TypeTkn) -> MonStgElt
{} 
    return ":";
end intrinsic;
intrinsic Sprint(t::LParen) -> MonStgElt {} return "("; end intrinsic;
intrinsic Sprint(t::LBrace) -> MonStgElt {} return "{"; end intrinsic;
intrinsic Sprint(t::LBrack) -> MonStgElt {} return "["; end intrinsic;
intrinsic Sprint(t::RParen) -> MonStgElt {} return ")"; end intrinsic;
intrinsic Sprint(t::RBrace) -> MonStgElt {} return "}"; end intrinsic;
intrinsic Sprint(t::RBrack) -> MonStgElt {} return "]"; end intrinsic;

intrinsic Sprint(t::TypeTkn) -> MonStgElt {}  return ":"; end intrinsic;
intrinsic Sprint(t::AssignTkn) -> MonStgElt {}  return "="; end intrinsic;
intrinsic Sprint(t::FuncTkn) -> MonStgElt {}    return "->"; end intrinsic;
intrinsic Sprint(t::TimesTkn) -> MonStgElt {}   return "*"; end intrinsic;
intrinsic Sprint(t::PlusTkn) -> MonStgElt {}    return "+"; end intrinsic;
intrinsic Sprint(t::MinusTkn) -> MonStgElt {}   return "-"; end intrinsic;
intrinsic Sprint(t::AndTkn) -> MonStgElt {}     return "&"; end intrinsic;
intrinsic Sprint(t::OrTkn) -> MonStgElt {}      return "|"; end intrinsic;

intrinsic Sprint(t::TraitTkn) -> MonStgElt {}    return "trait"; end intrinsic;
intrinsic Sprint(t::DefTkn) -> MonStgElt {}      return "def"; end intrinsic;
intrinsic Sprint(t::IfTkn) -> MonStgElt {}       return "if"; end intrinsic;
intrinsic Sprint(t::ThenTkn) -> MonStgElt {}     return "then"; end intrinsic;
intrinsic Sprint(t::ElseTkn) -> MonStgElt {}     return "else"; end intrinsic;


intrinsic Sprint(t::VarTkn) -> MonStgElt {} 
    return "<" cat Sprint(t`name) cat ">";
end intrinsic;

intrinsic Print(t::Tkn) {} print( Sprint(t) ); end intrinsic;

