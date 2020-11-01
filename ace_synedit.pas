unit ace_synedit;

{**************************************************************
*  A Part of Anoa-Core-Editor                                 *
*  See https://github.com/ah4d1/anoa-core-editor              *
**************************************************************}

interface

uses
  Classes, SysUtils, SynEdit, Graphics;

type
  TAceSeTheme = (aceSeThemeNormal,aceSeThemeDark);
  TAceCustomSynEdit = class(TSynEdit)
  private
    FSynEditColor : TColor;
    FSynEditFontColor : TColor;
    FGutterColor : TColor;
    FGutterMarkupColor : TColor;
    FLineHighlightColor : TColor;
    FCommentAttriColor : TColor;
    FKeyAttriColor : TColor;
    FTheme : TAceSeTheme;
    function GetTheme : TAceSeTheme;
    procedure SetTheme (AValue : TAceSeTheme);
    procedure _DefaultColor;
    procedure _ThemeNormal;
    procedure _ThemeDark;
  public
    property vTheme : TAceSeTheme read GetTheme write SetTheme default aceSeThemeNormal;
    constructor Create (AOwner: TComponent); override;
    procedure fcUndo;
    procedure fcRedo;
    procedure fcCopy;
    procedure fcCut;
    procedure fcPaste;
    procedure fcSelectAll;
  end;
  TAceSynEdit = class(TAceCustomSynEdit)
  published
    property vTheme;
  end;

procedure Register;

implementation

uses
  ac_color;

procedure Register;
begin
  RegisterComponents('AnoaCoreEditor',[TAceSynEdit]);
end;

constructor TAceCustomSynEdit.Create (AOwner : TComponent);
begin
  inherited Create(AOwner);
  Self._DefaultColor;
end;

procedure TAceCustomSynEdit.fcUndo;
begin
  Self.Undo;
end;

procedure TAceCustomSynEdit.fcRedo;
begin
  Self.Redo;
end;

procedure TAceCustomSynEdit.fcCopy;
begin
  Self.CopyToClipboard;
end;

procedure TAceCustomSynEdit.fcCut;
begin
  Self.CutToClipboard;
end;

procedure TAceCustomSynEdit.fcPaste;
begin
  Self.PasteFromClipboard;
end;

procedure TAceCustomSynEdit.fcSelectAll;
begin
  Self.SelectAll;
end;

function TAceCustomSynEdit.GetTheme : TAceSeTheme;
begin
  Result := Self.FTheme;
end;

procedure TAceCustomSynEdit.SetTheme (AValue : TAceSeTheme);
begin
  Self.FTheme := AValue;
  if Self.FTheme = aceSeThemeNormal then
    Self._ThemeNormal
  else
    Self._ThemeDark
  ;
end;

procedure TAceCustomSynEdit._DefaultColor;
begin
  Self.FSynEditColor := clWhite;
  Self.FSynEditFontColor := clBlack;
  Self.FGutterColor := clBtnFace;
  Self.FGutterMarkupColor := clBtnFace;
  Self.FLineHighlightColor := $00EFE8D6;
  Self.FCommentAttriColor := clRed;
  Self.FKeyAttriColor := clBlue;
end;

procedure TAceCustomSynEdit._ThemeNormal;
begin
  Self.Color := Self.FSynEditColor;
  Self.Font.Color := Self.FSynEditFontColor;
  Self.Gutter.Color := Self.FGutterColor;
  Self.Gutter.Parts[1].MarkupInfo.Background := Self.FGutterMarkupColor;
  Self.LineHighlightColor.Background := Self.FLineHighlightColor;
  Self.FCommentAttriColor := Self.FCommentAttriColor;
  Self.FKeyAttriColor := Self.FKeyAttriColor;
end;

procedure TAceCustomSynEdit._ThemeDark;
begin
  Self.Color := vacColor.fcInvert(Self.FSynEditColor);
  Self.Font.Color := vacColor.fcInvert(Self.FSynEditFontColor);
  Self.Gutter.Color := vacColor.fcInvert(Self.FGutterColor);
  Self.Gutter.Parts[1].MarkupInfo.Background := vacColor.fcInvert(Self.FGutterMarkupColor);
  Self.LineHighlightColor.Background := vacColor.fcInvert(Self.FLineHighlightColor);
  Self.FCommentAttriColor := vacColor.fcInvert(Self.FCommentAttriColor);
  Self.FKeyAttriColor := vacColor.fcInvert(Self.FKeyAttriColor);
end;

end.

