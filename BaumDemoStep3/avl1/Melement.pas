unit mElement;

interface

type TSortElement = class(TObject)
     public
       function EQ (Elem: TSortElement): Boolean; virtual; abstract;
       function NE (Elem: TSortElement): Boolean; virtual; abstract;
       function LT (Elem: TSortElement): Boolean; virtual; abstract;
       function LE (Elem: TSortElement): Boolean; virtual; abstract;
       function GT (Elem: TSortElement): Boolean; virtual; abstract;
       function GE (Elem: TSortElement): Boolean; virtual; abstract;
     end;

implementation

end.
