unit ace_synhighlighter;

{**************************************************************
*  A Part of Anoa-Core-Editor                                 *
*  See https://github.com/ah4d1/anoa-core-editor              *
**************************************************************}

interface

uses
  Classes, SysUtils, SynEdit, Graphics, Dialogs, SynEditHighlighter, SynFacilHighlighter,
  SynHighlighterBat, SynHighlighterCobol, SynHighlighterCS, SynHighlighterCSS,
  SynHighlighterHTML, SynHighlighterIni, SynHighlighterJava, SynHighlighterJScript,
  SynHighlighterJSON, SynHighlighterPas, SynHighlighterPHP, SynHighlighterPython,
  SynHighlighterRuby, SynHighlighterSQL, SynHighlighterXML;

type
  TAceShTheme = (aceShThemeNormal,aceShThemeDark);
  TAceShLang = (aceShLangNone,aceShLangBatch,aceShLangCobol,aceShLangCSharp,aceShLangCSS,
    aceShLangHTML,aceShLangIni,aceShLangJava,aceShLangJavaScript,aceShLangJSON,aceShLangPascal,
    aceShLangPHP,aceShLangPython,aceShLangR,aceShLangRuby,aceShLangSQL,aceShLangXML
  );
  TAceCustomSynHighlighter = class(TComponent)
  private
    FLang : TAceShLang;
    FLangTxt : WideString;
    FLangResWordFile : WideString;
    FLangs : TStringList;
    FReservedWords : TStringList;
    FAddOnHLDir : string; {for TSynFacilSyn}
    {Attribute Colors}
    FCommentAttriColor : TColor;
    FKeyAttriColor : TColor;
    {Highlighter}
    FNone   : TSynCustomHighLighter;
    FBatch  : TSynBatSyn;
    FCobol  : TSynCobolSyn;
    FCSharp : TSynCSSyn;
    FCSS    : TSynCSSSyn;
    FHTML   : TSynHTMLSyn;
    FIni    : TSynIniSyn;
    FJava   : TSynJavaSyn;
    FJavaScript : TSynJScriptSyn;
    FJSON   : TSynJSONSyn;
    FPascal : TSynPasSyn;
    FPHP    : TSynPHPSyn;
    FPython : TSynPythonSyn;
    FR      : TSynFacilSyn;
    FRuby   : TSynRubySyn;
    FSQL    : TSynSQLSyn;
    FXML    : TSynXMLSyn;
    {Ext}
    FExt : string;
    {Highlighter}
    FHighlighter : TSynCustomHighlighter;
    {Theme}
    FTheme : TAceShTheme;
    {Lang}
    function GetLang : TAceShLang;
    procedure SetLang (AValue : TAceShLang);
    {Default Filter}
    function GetDefaultFilter : WideString;
    {Ext}
    function GetExt : string;
    procedure SetExt (AValue : string);
    {Theme}
    procedure _ThemeNormal;
    procedure _ThemeDark;
    function GetTheme : TAceShTheme;
    procedure SetTheme (AValue : TAceShTheme);
    {Set Color}
    procedure fcSetColor (ALang : TSynCustomHighlighter);
    procedure fcSetColor (ALang : TSynCustomHighlighter; AComment : Boolean);
    procedure fcSetColorFacil (ALang : TSynFacilSyn);
    procedure fcReserveWords (ADir : string);
  public
    property vAddOnHLDir : string read FAddOnHLDir write FAddOnHLDir;
    {Attribute Colors}
    property vCommentAttriColor : TColor read FCommentAttriColor write FCommentAttriColor;
    property vKeyAttriColor : TColor read FKeyAttriColor write FKeyAttriColor;
    {Highlighter}
    property vNone : TSynCustomHighLighter read FNone write FNone;
    property vBatch : TSynBatSyn read FBatch write FBatch;
    property vCobol : TSynCobolSyn read FCobol write FCobol;
    property vCSharp : TSynCSSyn read FCSharp write FCSharp;
    property vCSS : TSynCSSSyn read FCSS write FCSS;
    property vHTML : TSynHTMLSyn read FHTML write FHTML;
    property vIni : TSynIniSyn read FIni write FIni;
    property vJava : TSynJavaSyn read FJava write FJava;
    property vJavaScript : TSynJScriptSyn read FJavaScript write FJavaScript;
    property vJSON : TSynJSONSyn read FJSON write FJSON;
    property vPascal : TSynPasSyn read FPascal write FPascal;
    property vPHP : TSynPHPSyn read FPHP write FPHP;
    property vPython : TSynPythonSyn read FPython write FPython;
    property vR : TSynFacilSyn read FR write FR;
    property vRuby : TSynRubySyn read FRuby write FRuby;
    property vSQL : TSynSQLSyn read FSQL write FSQL;
    property vXML : TSynXMLSyn read FXML write FXML;
    {}
    property vLang : TAceShLang read GetLang write SetLang default aceShLangNone;
    property vLangTxt : WideString read FLangTxt write FLangTxt;
    property vLangs : TStringList read FLangs write FLangs;
    property vLangResWordFile : WideString read FLangResWordFile write FLangResWordFile;
    property vReservedWords : TStringList read FReservedWords write FReservedWords;
    property vDefaultFilter : WideString read GetDefaultFilter;
    property vExt : string read GetExt write SetExt;
    property vHighlighter : TSynCustomHighlighter read FHighlighter;
    property vTheme : TAceShTheme read GetTheme write SetTheme default aceShThemeNormal;
    constructor Create (AOwner: TComponent); override;
    procedure fcInit (AResWordDir : string);
  end;
  TAceSynHighlighter = class(TAceCustomSynHighlighter)
  published
    property vLang;
  end;

procedure Register;

implementation

uses
  ac_filedir, ac_string, ac_stringlist;

procedure Register;
begin
  RegisterComponents('AnoaCoreEditor',[TAceSynHighlighter]);
end;

constructor TAceCustomSynHighlighter.Create (AOwner : TComponent);
begin
  inherited Create(AOwner);
  Self.FAddOnHLDir := '';
  {Attribute Colors}
  Self.FCommentAttriColor := clRed;
  Self.FKeyAttriColor := clBlue;
  {Highlighter}
  Self.FNone   := nil;
  Self.FBatch  := TSynBatSyn.Create(Self);
  Self.FCobol  := TSynCobolSyn.Create(Self);
  Self.FCSharp := TSynCSSyn.Create(Self);
  Self.FCSS    := TSynCSSSyn.Create(Self);
  Self.FHTML   := TSynHTMLSyn.Create(Self);
  Self.FIni    := TSynIniSyn.Create(Self);
  Self.FJava   := TSynJavaSyn.Create(Self);
  Self.FJavaScript := TSynJScriptSyn.Create(Self);
  Self.FJSON   := TSynJSONSyn.Create(Self);
  Self.FPascal := TSynPasSyn.Create(Self);
  Self.FPHP    := TSynPHPSyn.Create(Self);
  Self.FPython := TSynPythonSyn.Create(Self);
  Self.FR      := TSynFacilSyn.Create(Self);
  Self.FRuby   := TSynRubySyn.Create(Self);
  Self.FSQL    := TSynSQLSyn.Create(Self);
  Self.FXML    := TSynXMLSyn.Create(Self);
  {Lang}
  Self.vLangTxt := '|Batch|COBOL|C#|CSS|HTML|INI|Java|JavaScript|JSON|Pascal|'
    + 'PHP|Python|R|Ruby|SQL|XML'
  ;
  Self.vLangResWordFile := 'none|batch|cobol|cs|css|html|ini|java|javascript|json|pascal'
    + '|php|python|r|ruby|sql|xml'
  ;
  Self.vLangs := vacString.fcSplit(string(Self.vLangResWordFile),Char('|'));
  Self.vReservedWords := TStringList.Create;
  {Set Color}
  Self.fcSetColor(Self.FBatch);
  Self.fcSetColor(Self.FCobol);
  Self.fcSetColor(Self.FCSharp);
  Self.fcSetColor(Self.FCSS);
  Self.fcSetColor(Self.FHTML);
  Self.fcSetColor(Self.FIni);
  Self.fcSetColor(Self.FJava);
  Self.fcSetColor(Self.FJavaScript);
  Self.fcSetColor(Self.FJSON,False);
  Self.fcSetColor(Self.FPascal);
  Self.fcSetColor(Self.FPHP);
  Self.fcSetColor(Self.FPython);
  Self.fcSetColor(Self.FRuby);
  Self.fcSetColor(Self.FSQL);
  Self.fcSetColor(Self.FXML);
  {Default Filter for TSynFacilSyn}
  Self.FR.DefaultFilter := 'R Files (*.R)|*.R';
end;

procedure TAceCustomSynHighlighter.fcInit (AResWordDir : string);
begin
  Self.fcReserveWords(AResWordDir);
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
    aceShLangBatch  : Self.FHighlighter := Self.FBatch;
    aceShLangCobol  : Self.FHighlighter := Self.FCobol;
    aceShLangCSharp : Self.FHighlighter := Self.FCSharp;
    aceShLangCSS    : Self.FHighlighter := Self.FCSS;
    aceShLangHTML   : Self.FHighlighter := Self.FHTML;
    aceShLangIni    : Self.FHighlighter := Self.FIni;
    aceShLangJava   : Self.FHighlighter := Self.FJava;
    aceShLangJavaScript : Self.FHighlighter := Self.FJavaScript;
    aceShLangJSON   : Self.FHighlighter := Self.FJSON;
    aceShLangPascal : Self.FHighlighter := Self.FPascal;
    aceShLangPHP    : Self.FHighlighter := Self.FPHP;
    aceShLangPython : Self.FHighlighter := Self.FPython;
    aceShLangR      : Self.FHighlighter := Self.FR;
    aceShLangRuby   : Self.FHighlighter := Self.FRuby;
    aceShLangSQL    : Self.FHighlighter := Self.FSQL;
    aceShLangXML    : Self.FHighlighter := Self.FXML;
  end;
  {Only for descendants of TSynFacilSyn}
  Self.FR.LoadFromFile(Self.vAddOnHLDir + 'r.xml');
  Self.fcSetColorFacil(Self.FR);
end;

procedure TAceCustomSynHighlighter.fcReserveWords (ADir : string);
var
  i : Integer;
  LLangs : TStringList;
  LResWordList : TStringList;
  LResWord : WideString;
begin
  LLangs := Self.vLangs;
  for i := 0 to LLangs.Count - 1 do
  begin
    LResWordList := vacFileDir.fcFileToStringList(ADir + LLangs[i] + '.rw');
    LResWord := vacStringList.fcToDelimited(LResWordList,'|');
    Self.vReservedWords.Add(string(LResWord));
  end;
end;

function TAceCustomSynHighlighter.GetDefaultFilter : WideString;
begin
  Result := ''
    + 'All Files (*.*)|*.*'
    + '|' + Self.FBatch.DefaultFilter
    + '|' + Self.FCobol.DefaultFilter
    + '|' + Self.FCSharp.DefaultFilter
    + '|' + Self.FCSS.DefaultFilter
    + '|' + Self.FHTML.DefaultFilter
    + '|' + Self.FIni.DefaultFilter
    + '|' + Self.FJava.DefaultFilter
    + '|' + Self.FJavaScript.DefaultFilter
    + '|' + Self.FJSOn.DefaultFilter
    + '|' + Self.FPascal.DefaultFilter
    + '|' + Self.FPHP.DefaultFilter
    + '|' + Self.FPython.DefaultFilter
    + '|' + Self.FR.DefaultFilter
    + '|' + Self.FRuby.DefaultFilter
    + '|' + Self.FSQL.DefaultFilter
    + '|' + Self.FXML.DefaultFilter
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
  if vacFileDir.fcIsExt(AValue,Self.FBatch.DefaultFilter) then LLang := aceShLangBatch
    else if vacFileDir.fcIsExt(AValue,Self.FCobol.DefaultFilter) then LLang := aceShLangCobol
    else if vacFileDir.fcIsExt(AValue,Self.FCSharp.DefaultFilter) then LLang := aceShLangCSharp
    else if vacFileDir.fcIsExt(AValue,Self.FCSS.DefaultFilter) then LLang := aceShLangCSS
    else if vacFileDir.fcIsExt(AValue,Self.FHTML.DefaultFilter) then LLang := aceShLangHTML
    else if vacFileDir.fcIsExt(AValue,Self.FIni.DefaultFilter) then LLang := aceShLangIni
    else if vacFileDir.fcIsExt(AValue,Self.FJava.DefaultFilter) then LLang := aceShLangJava
    else if vacFileDir.fcIsExt(AValue,Self.FJavaScript.DefaultFilter) then LLang := aceShLangJavaScript
    else if vacFileDir.fcIsExt(AValue,Self.FJSON.DefaultFilter) then LLang := aceShLangJSON
    else if vacFileDir.fcIsExt(AValue,Self.FPascal.DefaultFilter) then LLang := aceShLangPascal
    else if vacFileDir.fcIsExt(AValue,Self.FPHP.DefaultFilter) then LLang := aceShLangPHP
    else if vacFileDir.fcIsExt(AValue,Self.FPython.DefaultFilter) then LLang := aceShLangPython
    else if vacFileDir.fcIsExt(AValue,Self.FR.DefaultFilter) then LLang := aceShLangR
    else if vacFileDir.fcIsExt(AValue,Self.FRuby.DefaultFilter) then LLang := aceShLangRuby
    else if vacFileDir.fcIsExt(AValue,Self.FSQL.DefaultFilter) then LLang := aceShLangSQL
    else if vacFileDir.fcIsExt(AValue,Self.FXML.DefaultFilter) then LLang := aceShLangXML
  ;
  Self.FLang := LLang;
end;

function TAceCustomSynHighlighter.GetTheme : TAceShTheme;
begin
  Result := Self.FTheme;
end;

procedure TAceCustomSynHighlighter.SetTheme (AValue : TAceShTheme);
begin
  Self.FTheme := AValue;
  if Self.FTheme = aceShThemeNormal then
    Self._ThemeNormal
  else
    Self._ThemeDark
  ;
end;

procedure TAceCustomSynHighlighter._ThemeNormal;
begin
  ShowMessage('TEST');
end;

procedure TAceCustomSynHighlighter._ThemeDark;
begin
  //
end;

procedure TAceCustomSynHighlighter.fcSetColor (ALang : TSynCustomHighlighter);
begin
  ALang.KeywordAttribute.Foreground := Self.FKeyAttriColor;
  ALang.KeywordAttribute.Style := [fsBold];
  ALang.CommentAttribute.Foreground := Self.FCommentAttriColor;
  ALang.CommentAttribute.Style := [fsItalic];
end;

procedure TAceCustomSynHighlighter.fcSetColor (ALang : TSynCustomHighlighter; AComment : Boolean);
begin
  if AComment then ALang.CommentAttribute.Foreground := Self.FCommentAttriColor;
  ALang.KeywordAttribute.Foreground := Self.FKeyAttriColor;
end;

procedure TAceCustomSynHighlighter.fcSetColorFacil (ALang : TSynFacilSyn);
begin
  ALang.tkKeyword.Foreground := clBlue;
  ALang.tkKeyword.Style := [fsBold];
  ALang.tkComment.Foreground := clRed;
  ALang.tkComment.Style := [fsItalic];
end;

end.

