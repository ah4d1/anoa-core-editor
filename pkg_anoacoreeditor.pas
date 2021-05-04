{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit pkg_anoacoreeditor;

{$warn 5023 off : no warning about unused units}
interface

uses
  ace_synedit, ace_synhighlighter, SynFacilHighlighter, ace_atsynedit, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ace_synedit', @ace_synedit.Register);
  RegisterUnit('ace_synhighlighter', @ace_synhighlighter.Register);
end;

initialization
  RegisterPackage('pkg_anoacoreeditor', @Register);
end.
