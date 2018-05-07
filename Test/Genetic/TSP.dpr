program TSP;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {Form1},
  untTspGenetic in 'untTspGenetic.pas',
  Cromosomi in '..\..\Genetic\Cromosomi.pas',
  GPGene in '..\..\Genetic\GPGene.pas',
  MathUtil in '..\..\Genetic\MathUtil.pas',
  Population in '..\..\Genetic\Population.pas',
  SelezAlgoritmi in '..\..\Genetic\SelezAlgoritmi.pas',
  NeuralNetDef in '..\..\Neuro\NeuralNetDef.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
