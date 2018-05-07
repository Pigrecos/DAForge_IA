program RL;

uses
  Forms,
  RLTest in 'RLTest.pas' {frmMain},
  MachineLearning in '..\..\Reinforcement Learning\MachineLearning.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
