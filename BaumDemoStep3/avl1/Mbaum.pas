unit mBaum;

interface

uses classes, SysUtils, mElement,stdctrls;

const B_LEFTHANGING             = -1;
      B_NOHANGING               =  0;
      B_RIGHTHANGING            =  1;

type   PTreeNode = ^TTreeNode;
       TTreeNode = record
        hKnoten: TObject;
        hleft, hright: PTreeNode;
        hBalance: integer;
      end;

      TAVLBaum = class(TObject)
        private
          aRoot: PTreeNode;
        public
          constructor Create;
          destructor destroy;
          function Vorhanden(Elem: TSortElement): boolean;
          function GetRoot: PTreeNode;
          procedure clear;
          procedure Insert(Elem: TSortElement; aListbox: TListbox);
          procedure Delete(Elem: TSortElement; aListbox: TListbox);
      end;

type TKnoten = class (TSortElement)
       private
         FInhalt: integer;
       public
         constructor Create; virtual;
         destructor Destroy; override;
         procedure Belegen (Wert: integer); virtual;
         function GetElement: integer; virtual;

         function EQ (Elem: TSortElement): Boolean; override;
         function NE (Elem: TSortElement): Boolean; override;
         function GT (Elem: TSortElement): Boolean; override;
         function LT (Elem: TSortElement): Boolean; override;
         function GE (Elem: TSortElement): Boolean; override;
         function LE (Elem: TSortElement): Boolean; override;
     end;

implementation

{ TAVLBaum **************************** }
constructor TAVLBaum.Create;
begin
  inherited Create;
  aRoot := NIL;
end;


procedure TAVLBaum.clear;
  procedure deleterecursive(var aNode: PTreeNode);
  begin
    if aNode <> NIL then begin
      if aNode^.hKnoten <> NIL then aNode^.hKnoten.destroy;
      if aNode^.hLeft <> NIL then deleterecursive(aNode^.hleft);
      if aNode^.hRight <> NIL then deleterecursive(aNode^.hRight);
      dispose(aNode);
      aNode := NIL;
    end;
  end;

begin
  if aRoot <> NIL then
    deleterecursive(aRoot);
end;

destructor TAVLBaum.destroy;
begin
  if aRoot <> NIL then clear;
  aRoot := NIL;
  inherited destroy;
end;

function TAVLBaum.GetRoot: PTreeNode;
begin
  GetRoot := aRoot;
end;

function TAVLBaum.Vorhanden(Elem: TSortElement): boolean;
  function DoesEqual(Elem: TSortElement; aNode: PTreeNode): boolean;
  begin
    DoesEqual := false;
    if aNode = NIL then exit;
    if Elem.LT(TSortElement(aNode^.hKnoten)) then
       DoesEqual := DoesEqual(Elem, aNode^.hLeft);
    if Elem.GT(TSortElement(aNode^.hKnoten)) then
       DoesEqual := DoesEqual(Elem, aNode^.hRight);
    if Elem.EQ(TSortElement(aNode^.hKnoten)) then DoesEqual := true;
  end;

begin
  Vorhanden := false;
  if aRoot = NIL then exit;
  Vorhanden := DoesEqual(Elem, aRoot);
end;

procedure TAVLBaum.Insert (Elem: TSortElement; aListbox: TListbox);

  procedure addaNode(Elem: TSortElement; var p: PTreeNode;
            var addednode: boolean; aListbox: TListbox);
  var p1, p2: PTreeNode;
  begin
    if p = NIL then begin { Ende des Astes, Knoten einfügen! }
      alistbox.items.add('Hänge ' + inttostr(TKnoten(Elem).GetElement) + ' an');
      alistbox.Repaint;
      new(p);
      addednode := True;
      with p^ do begin
        hleft := NIL;
        hright := NIL;
        hKnoten := Elem;
        hBalance := B_NOHANGING;
      end;
    end else if Elem.LT(TSortElement(p^.hKnoten)) then begin
      alistbox.items.add('linker Teilbaum für ' + inttostr(TKnoten(Elem).GetElement)
      + ' ausgewählt. (Aktueller Knoten: ' + inttostr(TKnoten(p^.hKnoten).GetElement)
      +').');
      alistbox.Repaint;
      addaNode(Elem, p^.hLeft, addednode, aListbox);
      if addednode then { linker Ast wurde länger }
        case p^.hBalance of
          B_RIGHTHANGING:
            begin
              alistbox.items.add('Knoten ' + inttostr(TKnoten(p^.hKnoten).GetElement) +
                'war rechtslastig, nun ausgeglichen!');
      alistbox.Repaint;
              p^.hBalance := B_NOHANGING;
              addednode := false;
            end;
          B_NOHANGING:
            begin
              p^.hBalance := B_LEFTHANGING;
              alistbox.items.add('Knoten ' + inttostr(TKnoten(p^.hKnoten).GetElement) +
                'war ausgeglichen, nun linkslastig!');
      alistbox.Repaint;
            end;
          B_LEFTHANGING: { Ausgleichen erforderlich! }
            begin
              alistbox.items.add('Knoten ' + inttostr(TKnoten(p^.hKnoten).GetElement) +
                'war linkslastig, nun Ausgleichen erforderlich!');
      alistbox.Repaint;
              p1 := p^.hLeft;
              if p1^.hBalance = B_LEFTHANGING then begin { LL-Rotation }
                alistbox.items.add('Knoten ' + inttostr(TKnoten(p1^.hKnoten).GetElement) +
                'war auch linkslastig, also: LL-Rotation!');
      alistbox.Repaint;
                p^.hleft := p1^.hright; { Ein Fehler.... }
                p1^.hright := p;
                p^.hBalance := B_NOHANGING;
                p := p1;
              end else begin { LR-Doppelrotation }
                alistbox.items.add('Knoten ' + inttostr(TKnoten(p1^.hKnoten).GetElement) +
                'war rechtslastig, also: LR-Doppelrotation!');
      alistbox.Repaint;
                       {p=aktueller unausgeglichener Knoten!}

                       p1 := p^.hLeft; {#2}
                       p2 := p1^.hRight; {#4}
                       p1^.hRight := p2^.hLeft; {#3}
                       p2^.hleft := p1;{#2}
                       p^.hLeft := p2; {jenen innen gelegenen Knoten als linken Teimbaum nehmen}
                       { Das war die 1. Teilrotation }
                       p^.hLeft := p2^.hRight; {elemente >p2 u. <p}
                     if p2^.hBalance = B_LEFTHANGING then p^.hBalance := B_RIGHTHANGING
                        else p^.hBalance := B_NOHANGING;
                     if p2^.hBalance = B_LEFTHANGING then p1^.hBalance := B_LEFTHANGING
                        else p1^.hBalance := B_NOHANGING;
                       p2^.hRight := p; {Baum an p2 neu aufhängen!}
                       p := p2;


              end;
              p^.hBalance := B_NOHANGING;
              addednode := false;
            end;
      end;
    end else if Elem.GT(TSortElement(p^.hKnoten)) then begin
      alistbox.items.add('rechter Teilbaum für ' + inttostr(TKnoten(Elem).GetElement)
      + ' ausgewählt. (Aktueller Knoten: ' + inttostr(TKnoten(p^.hKnoten).GetElement)
      +').');
    alistbox.Repaint;
      addaNode(Elem, p^.hRight, addednode, aListbox);
      if addednode then { rechter Ast wurde länger }
        case p^.hBalance of
          B_LEFTHANGING:
            begin
              alistbox.items.add('Knoten ' + inttostr(TKnoten(p^.hKnoten).GetElement) +
              'war linkslastig, nun ausgeglichen!');
    alistbox.Repaint;
              p^.hBalance := B_NOHANGING;
              addednode := false;
            end;
          B_NOHANGING:
            begin
              p^.hBalance := B_RIGHTHANGING;
              alistbox.items.add('Knoten ' + inttostr(TKnoten(p^.hKnoten).GetElement) +
              'war ausgeglichen, nun rechtslastig!');
    alistbox.Repaint;
            end;
          B_RIGHTHANGING: { Ausgleichen erforderlich! }
            begin
              alistbox.items.add('Knoten ' + inttostr(TKnoten(p^.hKnoten).GetElement) +
              'war rechtslastig, nun Ausgleichen erforderlich!');
    alistbox.Repaint;
              p1 := p^.hright;
              if p1^.hBalance = B_RIGHTHANGING then begin { RR-Rotation }
                alistbox.items.add('Knoten ' + inttostr(TKnoten(p1^.hKnoten).GetElement) +
                'war auch rechtslastig, also: RR-Rotation!');
    alistbox.Repaint;
                p^.hRight := p1^.hLeft;
                p1^.hLeft := p;
                p^.hBalance := B_NOHANGING;
                p := p1;
              end else begin { RL-Doppelrotation }
                alistbox.items.add('Knoten ' + inttostr(TKnoten(p1^.hKnoten).GetElement) +
                'war linkslastig, also: RL-[Doppel]Rotation!');
    alistbox.Repaint;
                     {p=aktueller, unausgeglichener Knoten}

                       p1 := p^.hRight; {#2}
                       p2 := p1^.hLeft; {#4}
                       p1^.hLeft := p2^.hRight; {#3}
                       p2^.hRight := p1;{#2}
                       p^.hRight := p2; {jenen innen gelegenen Knoten als linken Teimbaum nehmen}
                       { Das war die 1. Teilrotation }
                       p^.hRight := p2^.hLeft; {elemente >p2 u. <p}
                     if p2^.hBalance = B_RIGHTHANGING then p^.hBalance := B_LEFTHANGING
                        else p^.hBalance := B_NOHANGING;
                     if p2^.hBalance = B_RIGHTHANGING then p1^.hBalance := B_RIGHTHANGING
                        else p1^.hBalance := B_NOHANGING;
                       p2^.hLeft := p; {Baum an p2 neu aufhängen!}
                       p := p2;

              end;
              p^.hBalance := B_NOHANGING;
              addednode := false;
            end;
        end;
    end else begin
      addednode := FALSE;
    end;
  end;

var addedanode: boolean;
begin
     if Vorhanden(Elem) then exit; { Knoten bereits vorhanden! }
     alistbox.items.add('--------- Neues Element einfgüen --------');
      alistbox.Repaint;
     if aRoot = NIL then begin { Baum leer }
       alistbox.items.add('Setze ' + inttostr(TKnoten(Elem).GetElement) +
                                 ' als Wurzel.');
      alistbox.Repaint;
       new(aRoot);
       aRoot^.hBalance := B_NOHANGING;
       aRoot^.hleft := NIL;
       aRoot^.hright := NIL;
       aRoot^.hKnoten := Elem;
     end else begin
       addedanode := false;
       addaNode(Elem, aRoot, addedanode, aListbox);
     end;
end;

procedure TAVLBaum.Delete (Elem: TSortElement; aListbox: TListbox);
  var q: PTreeNode;

  procedure balance1(var p: PTreeNode; var deletednode: Boolean; aListbox: TListbox);
  var p1, p2: PTreeNode;
      b1, b2: integer;
  begin
       {deletednode=true, linker Ast wurde kürzer}
    aListbox.items.add('linker Teilbaum wurde kürzer');
    case p^.hBalance of
      B_LEFTHANGING:
        begin
          p^.hBalance := B_NOHANGING;
          aListbox.items.add('Baum war linkslastig, daher nun ausgeglichen');
        end;
      B_NOHANGING:
        begin
          aListbox.items.add('Baum war ausgeglichen, daher nun rechtslastig');
          p^.hBalance := B_RIGHTHANGING;
          deletednode := false;
        end;
      B_RIGHTHANGING: { Ausgleichen erforderlich }
        begin
          aListbox.items.add('Baum war schon rechtslastig, daher Ausgleichen'
            + ' erforderlich');
          p1 := p^.hRight;
          b1 := p1^.hBalance;
          if b1 <> B_LEFTHANGING then begin { RR-Rotation }
            aListbox.items.add('rechter Teilbaum war nicht linkslastig, '
              + ' also RR-Rotation');
            p^.hRight := p1^.hLeft;
            p1^.hLeft := p;
            if b1 = B_NOHANGING then begin
              p^.hBalance := B_RIGHTHANGING;
              p1^.hBalance := B_LEFTHANGING;
              deletednode := false;
            end else begin
              p^.hBalance := B_NOHANGING;
              p1^.hBalance := B_NOHANGING;
            end;
            p := p1;
          end else begin { RL-Doppelrotation }
            aListbox.items.add('rechter Teilbaum war linkslastig, '
              + ' also RL-Doppelrotation');
            p2 := p1^.hLeft;
            b2 := p2^.hBalance;
            p1^.hLeft := p2^.hRight;
            p2^.hRight := p1;
            p^.hRight := p2^.hLeft; { und noch ein Fehler... }
            p2^.hLeft := p;
            if b2 = B_RIGHTHANGING then
              p^.hBalance := B_LEFTHANGING
            else
              p^.hBalance := B_NOHANGING;
            if b2 = B_LEFTHANGING then
              p1^.hBalance := B_RIGHTHANGING
            else
              p1^.hBalance := B_NOHANGING;
            p := p2;
            p2^.hBalance := B_NOHANGING;
          end;
        end;
    end;
  end;

  procedure balance2(var p: PTreeNode; var deletednode: Boolean; aListbox: TListbox);
  var p1, p2: PTreeNode;
      b1, b2: integer;
  begin
       {deletednode=true, rechter Ast wurde kürzer}
    aListbox.items.add('rechter Teilbaum wurde kürzer');
    case p^.hBalance of
      B_RIGHTHANGING:
        begin
          aListbox.items.add('rechter Teilbaum war rechtslastig, nun ausgeglichen');
          p^.hBalance := B_NOHANGING;
        end;
      B_NOHANGING:
        begin
          aListbox.items.add('rechter Teilbaum war ausgeglichen, nun linkslastig');
          p^.hBalance := B_LEFTHANGING;
          deletednode := false;
        end;
      B_LEFTHANGING: { Ausgleichen erforderlich }
        begin
          aListbox.items.add('Baum war schon linkslastig, nun Ausgeglichen' +
            ' erforderlich');
          p1 := p^.hLeft;
          b1 := p1^.hBalance;
          if b1 <> B_RIGHTHANGING then begin { LL-Rotation }
            aListbox.items.add('linker Teilbaum war nicht rechtslastig, also '
              + ' LL-Rotation');
            p^.hLeft := p1^.hRight;
            p1^.hRight := p;
            if b1 = B_NOHANGING then begin
              p1^.hBalance := B_RIGHTHANGING;
              p^.hBalance := B_LEFTHANGING;
              deletednode := false;
            end else begin
              p^.hBalance := B_NOHANGING;
              p1^.hBalance := B_NOHANGING;
            end;
            p:= p1;           { ein weiterer Fehler??? Ja! }
          end else begin { LR-Doppelrotation }
            aListbox.items.add('linker Teilbaum war rechtslastig, also '
              + ' LR-Doppelrotation');
            p2 := p1^.hRight;
            b2 := p2^.hBalance;
            p1^.hRight := p2^.hLeft;
            p2^.hLeft := p1;
            p^.hLeft := p2^.hRight;
            p2^.hRight := p;
            if b2 = B_LEFTHANGING then
              p^.hBalance := B_RIGHTHANGING
            else
              p^.hBalance := B_NOHANGING;
            if b2 = B_RIGHTHANGING then
              p1^.hBalance := B_LEFTHANGING
            else
              p1^.hBalance := B_NOHANGING;
            p := p2;
            p2^.hBalance := B_NOHANGING;
          end;
        end;
    end;
  end;

  procedure del(var r: PTreeNode; var deletednode: Boolean; aListbox: TListbox);
  begin
    if r^.hRight <> NIL then begin
{      aListbox.items.add('rechter Teilbaum ausgewählt (Aktueller Knoten '
      + inttostr(TKnoten(r^.hKnoten).GetElement) + ').');
 }     del(r^.hRight, deletednode, aListbox);
      if deletednode then balance2(r, deletednode, aListbox);
    end else begin
{      aListbox.items.add('rechter Teilbaum leer, ersetze Knoten '
      + inttostr(TKnoten(q^.hKnoten).GetElement) + ' durch '
      + inttostr(TKnoten(r^.hKnoten).GetElement) + '.');
 }    if (q <> NIL) and (r <> NIL) then begin
        q^.hKnoten := r^.hKnoten;
        r := r^.hLeft;
      end;
      deletednode := true;
    end;
  end;

  procedure dodelete(Elem: TSortElement; var p: PTreeNode;
            var deletednode: boolean; aListbox: TListbox);
  begin
    if p = NIL then exit; { Knoten nicht vorhanden! }
    if not Vorhanden(Elem) then exit;
    if Elem.LT(TSortElement(p^.hKnoten)) then begin
      aListbox.items.add('Wähle linken Teilbaum aus (Aktueller Knoten '
      + inttostr(TKnoten(p^.hKnoten).GetElement) + ').');
      dodelete(Elem, p^.hLeft, deletednode, aListbox);
      if deletednode then balance1(p, deletednode, aListbox);
    end else
    if Elem.GT(TSortElement(p^.hKnoten)) then begin
      aListbox.items.add('Wähle rechten Teilbaum aus (Aktueller Knoten '
      + inttostr(TKnoten(p^.hKnoten).GetElement) + ').');
      dodelete(Elem, p^.hRight, deletednode, aListbox);
      if deletednode then balance2(p, deletednode, aListbox);
    end else if Elem.EQ(TSortElement(p^.hKnoten)) then begin { Knoten entfernen }
      aListbox.items.add('Knoten gefunden ('
      + inttostr(TKnoten(p^.hKnoten).GetElement) + ').');
      q := p;
      if q^.hRight = NIL then begin
        aListbox.items.add('rechter Teilbaum leer, also durch linken Teilbaum '
        + 'ersetzen.');
        p := q^.hLeft;
        deletednode := true;
      end else if q^.hLeft = NIL then begin
        aListbox.items.add('linker Teilbaum leer, also durch linken Teilbaum '
        + 'ersetzen.');
        p := q^.hRight;
        deletednode := true;
      end else begin
        aListbox.items.add('Beide Teilbäume nicht leer, also del(lefttree)'
        + 'probieren.');
        del(q^.hLeft, deletednode, aListbox);
        if deletednode then begin
          aListbox.items.add('Knoten konnte gelöscht werden!');
          balance1(p, deletednode, aListbox);
        end;
      end;
      aListbox.items.add('Lösche Daten des Knoten');
      if q <> NIL then
{      if q^.hKnoten <> NIL then q^.hKnoten.destroy; CRASHES... WHYEVER
      dispose(q);}
    end;
  end;

var deletednode: boolean;
begin
     if aRoot = NIL then exit; { im leeren Baum gibt es nichts zu löschen! }
     aListbox.items.add('----------- Knoten löschen ----------------');
     deletednode := false;
     dodelete(Elem, aRoot, deletednode, aListbox);
     Elem.destroy;
end;


{ ******* Klasse TKnoten }


constructor TKnoten.Create;
begin
  Inherited Create;
  FInhalt := 0;
end;

destructor TKnoten.Destroy;
begin
  inherited Destroy;
end;

procedure TKnoten.Belegen (Wert: integer);
begin
  FInhalt := Wert;
end;

function TKnoten.GetElement: integer;
begin
  GetElement := FInhalt
end;

 function TKnoten.EQ (Elem: TSortElement): Boolean;
 begin
   EQ := (Self.FInhalt = TKnoten(Elem).FInhalt)
 end;

 function TKnoten.NE (Elem: TSortElement): Boolean;
 begin
   NE := (Self.FInhalt <> TKnoten(Elem).FInhalt)
 end;

 function TKnoten.GT (Elem: TSortElement): Boolean;
 begin
   GT := (Self.FInhalt > TKnoten(Elem).FInhalt)
 end;

 function TKnoten.LT (Elem: TSortElement): Boolean;
 begin
   LT := (Self.FInhalt < TKnoten(Elem).FInhalt)
 end;

 function TKnoten.GE (Elem: TSortElement): Boolean;
 begin
   GE := (Self.FInhalt >= TKnoten(Elem).FInhalt)
 end;

 function TKnoten.LE (Elem: TSortElement): Boolean;
 begin
    LE := (Self.FInhalt <= TKnoten(Elem).FInhalt)
 end;


end.

