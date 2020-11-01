unit ace_synhighlighter;

{**************************************************************
*  A Part of Anoa-Core-Editor                                 *
*  See https://github.com/ah4d1/anoa-core-editor              *
**************************************************************}

interface

uses
  Classes, SysUtils, SynEdit, Graphics, SynEditHighlighter, SynHighlighterCobol,
  SynHighlighterCS, SynHighlighterCSS, SynHighlighterHTML, SynHighlighterJava,
  SynHighlighterJSON, SynHighlighterPas, SynHighlighterPHP, SynHighlighterPython,
  SynHighlighterSQL;

type
  TAceShLang = (aceShLangNone,aceShLangCobol,aceShLangCS,aceShLangCSS,aceShLangHTML,aceShLangJava,
    aceShLangJSON,aceShLangPas,aceShLangPHP,aceShLangPython,aceShLangSQL
  );
  TAceCustomSynHighlighter = class(TComponent)
  private
    FLang : TAceShLang;
    {Attribute Colors}
    FCommentAttriColor : TColor;
    FKeyAttriColor : TColor;
    {Highlighter}
    FNone   : TSynCustomHighLighter;
    FCobol  : TSynCobolSyn;
    FCS     : TSynCSSyn;
    FCSS    : TSynCSSSyn;
    FHTML   : TSynHTMLSyn;
    FJava   : TSynJavaSyn;
    FJSON   : TSynJSONSyn;
    FPas    : TSynPasSyn;
    FPHP    : TSynPHPSyn;
    FPython : TSynPythonSyn;
    FSQL    : TSynSQLSyn;
    {Default Filter}
    FDefaultFilter : WideString;
    {Ext}
    FExt : string;
    {Highlighter}
    FHighlighter : TSynCustomHighlighter;
    {Lang}
    function GetLang : TAceShLang;
    procedure SetLang (AValue : TAceShLang);
    {Default Filter}
    function GetDefaultFilter : WideString;
    {Ext}
    function GetExt : string;
    procedure SetExt (AValue : string);
    {Set Color}
    procedure fcSetColor (ALang : TSynCustomHighlighter);
    procedure fcSetColor (ALang : TSynCustomHighlighter; AComment : Boolean);
  public
    {Attribute Colors}
    property vCommentAttriColor : TColor read FCommentAttriColor write FCommentAttriColor;
    property vKeyAttriColor : TColor read FKeyAttriColor write FKeyAttriColor;
    {Highlighter}
    property vNone : TSynCustomHighLighter read FNone write FNone;
    property vCobol : TSynCobolSyn read FCobol write FCobol;
    property vCS : TSynCSSyn read FCS write FCS;
    property vCSS : TSynCSSSyn read FCSS write FCSS;
    property vHTML : TSynHTMLSyn read FHTML write FHTML;
    property vJava : TSynJavaSyn read FJava write FJava;
    property vJSON : TSynJSONSyn read FJSON write FJSON;
    property vPas : TSynPasSyn read FPas write FPas;
    property vPHP : TSynPHPSyn read FPHP write FPHP;
    property vPython : TSynPythonSyn read FPython write FPython;
    property vSQL : TSynSQLSyn read FSQL write FSQL;
    {}
    property vLang : TAceShLang read GetLang write SetLang default aceShLangNone;
    property vDefaultFilter : WideString read GetDefaultFilter;
    property vExt : string read GetExt write SetExt;
    property vHighlighter : TSynCustomHighlighter read FHighlighter;
    constructor Create (AOwner: TComponent); override;
  end;
  TAceSynHighlighter = class(TAceCustomSynHighlighter)
  published
    property vLang;
  end;

procedure Register;

implementation

uses
  ac_filedir;

procedure Register;
begin
  RegisterComponents('AnoaCoreEditor',[TAceSynHighlighter]);
end;

constructor TAceCustomSynHighlighter.Create (AOwner : TComponent);
begin
  inherited Create(AOwner);
  {Attribute Colors}
  Self.FCommentAttriColor := clRed;
  Self.FKeyAttriColor := clBlue;
  {Highlighter}
  Self.FNone   := nil;
  Self.FCobol  := TSynCobolSyn.Create(AOwner);
  Self.FCS     := TSynCSSyn.Create(AOwner);
  Self.FCSS    := TSynCSSSyn.Create(AOwner);
  Self.FHTML   := TSynHTMLSyn.Create(AOwner);
  Self.FJava   := TSynJavaSyn.Create(AOwner);
  Self.FJSON   := TSynJSONSyn.Create(AOwner);
  Self.FPas    := TSynPasSyn.Create(AOwner);
  Self.FPHP    := TSynPHPSyn.Create(AOwner);
  Self.FPython := TSynPythonSyn.Create(AOwner);
  Self.FSQL    := TSynSQLSyn.Create(AOwner);
  {Set Color}
  Self.fcSetColor(Self.FCobol);
  Self.fcSetColor(Self.FCS);
  Self.fcSetColor(Self.FCSS);
  Self.fcSetColor(Self.FHTML);
  Self.fcSetColor(Self.FJava);
  Self.fcSetColor(Self.FJSON,False);
  Self.fcSetColor(Self.FPas);
  Self.fcSetColor(Self.FPHP);
  Self.fcSetColor(Self.FPython);
  Self.fcSetColor(Self.FSQL);
end;

function TAceCustomSynHighlighter.GetLang : TAceShLang;
begin
  Result := Self.FLang;
end;

procedure TAceCustomSynHighlighter.SetLang (AValue : TAceShLang);
begin
  Self.FLang := AValue;
  case Self.FLang of
    aceShLangNone   : Self.FHighlighter := Self.FNone;
    aceShLangCobol  : Self.FHighlighter := Self.FCobol;
    aceShLangCS     : Self.FHighlighter := Self.FCS;
    aceShLangCSS    : Self.FHighlighter := Self.FCSS;
    aceShLangHTML   : Self.FHighlighter := Self.FHTML;
    aceShLangJava   : Self.FHighlighter := Self.FJava;
    aceShLangJSON   : Self.FHighlighter := Self.FJSON;
    aceShLangPas    : Self.FHighlighter := Self.FPas;
    aceShLangPHP    : Self.FHighlighter := Self.FPHP;
    aceShLangPython : Self.FHighlighter := Self.FPython;
    aceShLangSQL    : Self.FHighlighter := Self.FSQL;
  end;
end;

function TAceCustomSynHighlighter.GetDefaultFilter : WideString;
begin
  Result := ''
    + 'All Files (*.*)|*.*'
    + '|' + Self.FCobol.DefaultFilter
    + '|' + Self.FCS.DefaultFilter
    + '|' + Self.FCSS.DefaultFilter
    + '|' + Self.FHTML.DefaultFilter
    + '|' + Self.FJava.DefaultFilter
    + '|' + Self.FJSOn.DefaultFilter
    + '|' + Self.FPas.DefaultFilter
    + '|' + Self.FPHP.DefaultFilter
    + '|' + Self.FPython.DefaultFilter
    + '|' + Self.FSQL.DefaultFilter
  ;
end;

function TAceCustomSynHighlighter.GetExt : string;
begin
  Result := Self.FExt;
end;

procedure TAceCustomSynHighlighter.SetExt (AValue : string);
var
  LLang : TAceShLang;
begin
  LLang := aceShLangNone;
  if vacFileDir.fcIsExt(AValue,Self.FCobol.DefaultFilter) then LLang := aceShLangCobol
    else if vacFileDir.fcIsExt(AValue,Self.FCS.DefaultFilter) then LLang := aceShLangCS
    else if vacFileDir.fcIsExt(AValue,Self.FCSS.DefaultFilter) then LLang := aceShLangCSS
    else if vacFileDir.fcIsExt(AValue,Self.FHTML.DefaultFilter) then LLang := aceShLangHTML
    else if vacFileDir.fcIsExt(AValue,Self.FJava.DefaultFilter) then LLang := aceShLangJava
    else if vacFileDir.fcIsExt(AValue,Self.FJSON.DefaultFilter) then LLang := aceShLangJSON
    else if vacFileDir.fcIsExt(AValue,Self.FPas.DefaultFilter) then LLang := aceShLangPas
    else if vacFileDir.fcIsExt(AValue,Self.FPHP.DefaultFilter) then LLang := aceShLangPHP
    else if vacFileDir.fcIsExt(AValue,Self.FPython.DefaultFilter) then LLang := aceShLangPython
    else if vacFileDir.fcIsExt(AValue,Self.FSQL.DefaultFilter) then LLang := aceShLangSQL
  ;
  Self.FLang := LLang;
end;

procedure TAceCustomSynHighlighter.fcSetColor (ALang : TSynCustomHighlighter);
begin
  ALang.CommentAttribute.Foreground := Self.FCommentAttriColor;
  ALang.KeywordAttribute.Foreground := Self.FKeyAttriColor;
end;

procedure TAceCustomSynHighlighter.fcSetColor (ALang : TSynCustomHighlighter; AComment : Boolean);
begin
  if AComment then ALang.CommentAttribute.Foreground := Self.FCommentAttriColor;
  ALang.KeywordAttribute.Foreground := Self.FKeyAttriColor;
end;

end.

