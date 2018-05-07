{*******************************************************}
{                                                       }
{       Tsp                                             }
{                                                       }
{                                                       }
{                                                       }
{*******************************************************}

unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,
  Vcl.Buttons, System.Math,VCLTee.TeeFunci,NeuralNetDef ;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    btnStart: TBitBtn;
    btnStop: TBitBtn;
    edtNumCitta: TEdit;
    btnGenMappa: TBitBtn;
    Label1: TLabel;
    edtNumPopolazione: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    cbMetodSelezione: TComboBox;
    cbGreedyCroosover: TCheckBox;
    edtNumCicli: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtCicloCur: TEdit;
    Label6: TLabel;
    edtPathLen: TEdit;
    Label7: TLabel;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure btnGenMappaClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    citiesCount,
		populationSize ,
		iterations,
		selectionMethod  : Integer;
		greedyCrossover,
    needToStop       : Boolean;
    map              : AAdouble;

    procedure EnableControls(enable: Boolean);
    procedure UpdateSettings;
    procedure GenerateMap;
    procedure RicercaSoluzione;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
     uses Population,untTspGenetic,Cromosomi,SelezAlgoritmi;
{$R *.dfm}

// Enable/disale controls (safe for threading)
procedure TForm1.btnGenMappaClick(Sender: TObject);
begin
      // get cities count
			try
        citiesCount := Max( 5, Min( 50, StrToInt( edtNumCitta.Text ) ) );
      except
       	citiesCount := 20;
			end;
			edtNumCitta.Text := IntToStr(citiesCount);
      // regenerate map
			GenerateMap;
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
      // get population size
			try
        populationSize := Max( 10, Min( 100, StrToInt( edtNumPopolazione.Text ) ) );
      except
      	populationSize := 40;
			end;
			// iterations
			try
        iterations := Max( 0, StrToInt(edtNumCicli.Text ) );
      except
      	iterations := 100;
			end;
			// update settings controls
			UpdateSettings;

			selectionMethod := cbMetodSelezione.ItemIndex;
			greedyCrossover := cbGreedyCroosover.Checked;

			// disable all settings controls except "Stop" button
			EnableControls( false );

			// run worker thread
			needToStop := false;
			RicercaSoluzione
end;

procedure TForm1.RicercaSoluzione;
var
  fitnessFunction : TTSPFitnessFunction;
  population      : TPopulation;
  ancestor        : IChromosome;
  metodosel       : ISelectionMethod;
  i,j             : Integer;
  path            : AADouble;
  bestValue       : AWord;
begin
     // create fitness function
			fitnessFunction := TTSPFitnessFunction.Create( map );
      if   greedyCrossover then ancestor :=  TTSPChromosome.Create( map )
      else                      ancestor :=  TPermutationChromosome.Create( citiesCount );

      case selectionMethod of
        0 : metodosel :=  TEliteSelection.Create;
        1 : metodosel :=  TRankSelection.Create;
      else  metodosel :=  TRankSelection.Create;
      end;

			// create population
			population      :=  TPopulation.Create( populationSize, ancestor, fitnessFunction,  metodosel 	);
			// iterations
			i := 1;

			// path
			SetLength(path,citiesCount + 1, 2);
      // loop
			while  not needToStop  do
			begin
          // run one epoch of genetic algorithm
          population.RunEpoch( );

          // display current path
          bestValue := TPermutationChromosome(population.BestChromosome).Value;

          for j := 0 to citiesCount - 1 do
          begin
               path[j, 0] := map[bestValue[j], 0];
               path[j, 1] := map[bestValue[j], 1];
          end;
          path[citiesCount, 0] := map[bestValue[0], 0];
          path[citiesCount, 1] := map[bestValue[0], 1];

          PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
          for j := 0 to citiesCount - 1 do
          begin
              PaintBox1.Canvas.Ellipse(Trunc(map[j, 0]) +10-2, Trunc(map[j, 1]) +10-2, Trunc(map[j, 0]) +10+3, Trunc(map[j, 1]) +10+3);
              PaintBox1.Canvas.TextOut(Trunc(map[j, 0]) +10+5, Trunc(map[j, 1]) +10+5, IntToStr(j +1));
          end;
          for j := 0 to Length(path) - 2 do
          begin
                PaintBox1.Canvas.MoveTo(Trunc(path[j, 0])+10,Trunc(path[j, 1])+10);
                PaintBox1.Canvas.LineTo(Trunc(path[j+1, 0])+10 , Trunc(path[j+1, 1])+10 );
          end;

          // set current iteration's info
          edtCicloCur.Text := IntToStr(i) ;
          edtPathLen.Text  := FloatToStr(fitnessFunction.PathLength( population.BestChromosome ));

          // increase current iteration
          inc(i);

          if ( ( iterations <> 0 ) and ( i > iterations ) ) then break;
			end;
      // enable settings controls
			EnableControls( true );
end;

procedure TForm1.EnableControls(enable: Boolean) ;
begin
    edtNumCitta.Enabled       := enable;
    edtNumPopolazione.Enabled := enable;
    edtNumCicli.Enabled       := enable;
    cbMetodSelezione.Enabled  := enable;

    btnGenMappa.Enabled       := enable;

    btnStart.Enabled          := enable;
    btnStop.Enabled           := not enable;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    citiesCount    := 20;
		populationSize := 40;
		iterations     := 100;
		selectionMethod:= 0;
		greedyCrossover:= true;
    needToStop     := false;

    //
		cbMetodSelezione.ItemIndex := selectionMethod;
	  cbGreedyCroosover.Checked  := greedyCrossover;
		UpdateSettings;
	  GenerateMap;
end;

procedure TForm1.GenerateMap;
var
  i : Integer;
begin
     Randomize;
     // create coordinates array
     SetLength(map,citiesCount, 2);

     PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
		 for i := 0 to citiesCount - 1 do
		 begin
				map[i, 0] := Random( 400 );
				map[i, 1] := Random( 400 );
        PaintBox1.Canvas.Ellipse(Trunc(map[i, 0]) +10-2, Trunc(map[i, 1]) +10-2, Trunc(map[i, 0]) +10+3, Trunc(map[i, 1]) +10+3);
        PaintBox1.Canvas.TextOut(Trunc(map[i, 0]) +10+5, Trunc(map[i, 1]) +10+5, IntToStr(i +1));
     end;
end;

procedure TForm1.UpdateSettings;
begin
     edtNumCitta.Text		    := IntToStr(citiesCount);
		 edtNumPopolazione.Text	:= IntToStr(populationSize);
		 edtNumCicli.Text		    := IntToStr(iterations);
end;

end.
