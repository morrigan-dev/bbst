// Facebook-Icon - http://www.iconspedia.com/icon/facebook-2702.html
// Twitter-Icon - http://www.iconspedia.com/icon/twitter-social-icon-26658.html

unit unitInfoBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage, ShellApi;

type
  TfrmInfoBox = class(TForm)
    imgSignatur: TImage;
    shpRahmen: TShape;
    lblEntwickler: TLabel;
    lblName: TLabel;
    mmoInfo: TMemo;
    lblKontakt: TLabel;
    lblEmail: TLabel;
    edtEmail: TEdit;
    lblICQ: TLabel;
    edtICQ: TEdit;
    lblSkype: TLabel;
    edtSkype: TEdit;
    btOk: TButton;
    imgFacebook: TImage;
    imgGooglePlus: TImage;
    imgTwitter: TImage;
    procedure imgFacebookClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure imgGooglePlusClick(Sender: TObject);
    procedure imgTwitterClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmInfoBox: TfrmInfoBox;

implementation

{$R *.dfm}

procedure TfrmInfoBox.btOkClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmInfoBox.imgFacebookClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://www.facebook.com/profile.php?id=100003085658834'),
    nil, nil, SW_ShowNormal);
end;

procedure TfrmInfoBox.imgGooglePlusClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('https://plus.google.com/110456870101011596308/about'),
    nil, nil, SW_ShowNormal);
end;

procedure TfrmInfoBox.imgTwitterClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://twitter.com/#!/ThomasGattinger'),
    nil, nil, SW_ShowNormal);

end;

end.
