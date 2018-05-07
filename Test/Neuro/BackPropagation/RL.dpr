program RL;

uses
  Forms,
  RLTest in 'RLTest.pas' {frmMain},
  Apprendimento in '..\..\..\Neuro\Apprendimento.pas',
  FunzAttivazione in '..\..\..\Neuro\FunzAttivazione.pas',
  Layer in '..\..\..\Neuro\Layer.pas',
  Network in '..\..\..\Neuro\Network.pas',
  NeuralNetDef in '..\..\..\Neuro\NeuralNetDef.pas',
  Neuron in '..\..\..\Neuro\Neuron.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
