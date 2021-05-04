unit ace_atsynedit;

{**************************************************************
*  A Part of Anoa-Core-Editor                                 *
*  See https://github.com/ah4d1/anoa-core-editor              *
**************************************************************}

interface

uses
  Classes, SysUtils, SynEdit, Graphics, atsynedit, ace_synhighlighter;

type
  TAceCustomATSynEdit = class(TATSynEdit)
  private
    FSynEditColor : TColor;
    FSynEditFontColor : TColor;
    FGutterColor : TColor;
    FGutterMarkupColor : TColor;
    FLineHighlightColor : TColor;
    FCommentAttriColor : TColor;
    FKeyAttriColor : TColor;
    FSynHighlighter : TAceSynHighlighter;
    FTheme : TAceShTheme;
    procedure SetSynHighlighter (AValue : TAceSynHighlighter);
    function GetTheme : TAceShTheme;
    procedure SetTheme (AValue : TAceShTheme);
    procedure _DefaultColor;
    procedure _ThemeNormal;
    procedure _ThemeDark;
  public
    property vSynHighlighter : TAceSynHighlighter read FSynHighlighter write SetSynHighlighter;
    property vTheme : TAceShTheme read GetTheme write SetTheme default aceShThemeNormal;
    constructor Create (AOwner: TComponent); override;
    procedure fcUndo;
    procedure fcRedo;
    procedure fcCopy;
    procedure fcCut;
    procedure fcPaste;
    procedure fcSelectAll;
  end;
  TAceATSynEdit = class(TAceCustomATSynEdit)
  published
    property vSynHighlighter;
    property vTheme;
  end;

procedure Register;

implementation

uses
  ac_color;

procedure Register;
begin
  RegisterComponents('AnoaCoreEditor',[TAceATSynEdit]);
end;

constructor TAceCustomATSynEdit.Create (AOwner : TComponent);
begin
  inherited Create(AOwner);
  Self.Font.Name := 'Courier New';
  Self.Font.Quality := fqProof;
  Self.Font.Size := 9;
  Self._DefaultColor;
end;

procedure TAceCustomATSynEdit.SetSynHighlighter (AValue : TAceSynHighlighter);
begin
  Self.FSynHighlighter := AValue;
  // Self.Highlighter := Self.FSynHighlighter.vHighlighter;
end;

function TAceCustomATSynEdit.GetTheme : TAceShTheme;
begin
  Result := Self.FTheme;
end;

procedure TAceCustomATSynEdit.SetTheme (AValue : TAceShTheme);
begin
  Self.FTheme := AValue;
  if Self.vTheme = aceShThemeNormal then
    Self._ThemeNormal
  else
    Self._ThemeDark
  ;
  // Self.vSynHighlighter.vTheme := Self.vTheme; // ERROR HERE
end;

procedure TAceCustomATSynEdit._DefaultColor;
begin
  Self.FSynEditColor := clWhite;
  Self.FSynEditFontColor := clBlack;
  Self.FGutterColor := clBtnFace;
  Self.FGutterMarkupColor := clBtnFace;
  Self.FLineHighlightColor := $00EFE8D6;
  Self.FCommentAttriColor := clRed;
  Self.FKeyAttriColor := clBlue;
end;

procedure TAceCustomATSynEdit._ThemeNormal;
begin
  Self.Color := Self.FSynEditColor;
  Self.Font.Color := Self.FSynEditFontColor;
  // Self.Gutter.Color := Self.FGutterColor;
  // Self.Gutter.Parts[1].MarkupInfo.Background := Self.FGutterMarkupColor;
  // Self.LineHighlightColor.Background := Self.FLineHighlightColor;
  Self.FCommentAttriColor := Self.FCommentAttriColor;
  Self.FKeyAttriColor := Self.FKeyAttriColor;
end;

procedure TAceCustomATSynEdit._ThemeDark;
begin
  Self.Color := vacColor.fcInvert(Self.FSynEditColor);
  Self.Font.Color := vacColor.fcInvert(Self.FSynEditFontColor);
  // Self.Gutter.Color := vacColor.fcInvert(Self.FGutterColor);
  // Self.Gutter.Parts[1].MarkupInfo.Background := vacColor.fcInvert(Self.FGutterMarkupColor);
  // Self.LineHighlightColor.Background := vacColor.fcInvert(Self.FLineHighlightColor);
  Self.FCommentAttriColor := vacColor.fcInvert(Self.FCommentAttriColor);
  Self.FKeyAttriColor := vacColor.fcInvert(Self.FKeyAttriColor);
end;

procedure TAceCustomATSynEdit.fcUndo;
begin
  // Self.Undo;
end;

procedure TAceCustomATSynEdit.fcRedo;
begin
  // Self.Redo;
end;

procedure TAceCustomATSynEdit.fcCopy;
begin
  // Self.CopyToClipboard;
end;

procedure TAceCustomATSynEdit.fcCut;
begin
  // Self.CutToClipboard;
end;

procedure TAceCustomATSynEdit.fcPaste;
begin
  // Self.PasteFromClipboard;
end;

procedure TAceCustomATSynEdit.fcSelectAll;
begin
  // Self.SelectAll;
end;

end.

