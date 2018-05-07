unit RLTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,MachineLearning, ExtCtrls, StdCtrls, Grids,
  BaseGrid, AdvGrid,Math, AdvObj, Vcl.Buttons;

type
  rAgente = record
    StartX : Integer;
    StartY : Integer;
    StopX  : Integer;
    StopY  : Integer;
  end;

  TfrmMain = class(TForm)
    dlgOpen: TOpenDialog;
    GroupBox1: TGroupBox;
    btnStart: TBitBtn;
    btnStop: TBitBtn;
    btnShowSol: TBitBtn;
    stCiclo: TStaticText;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    edtRMove: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    cbAlgo: TComboBox;
    edtEsplor: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtAppren: TEdit;
    edtCicli: TEdit;
    Label4: TLabel;
    Label7: TLabel;
    edtRMuro: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    edtRObiet: TEdit;
    GroupBox3: TGroupBox;
    stDim: TStaticText;
    Label9: TLabel;
    btnLoad: TBitBtn;
    sgCellWord: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnShowSolClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    procedure Loadfile;
    procedure WordSize(x, y: Integer);
    procedure Split(const Delimiter: Char; Input: string;
      const Strings: TStrings);
    procedure ShowSetting;
    procedure GetSetting;
    procedure EnableControl(lEnable: Boolean);
    procedure QLearningThRead;
    function UpdateAgentPosition(var currentX, currentY: Integer; const action: Integer):Double;
    function GetStateNumber(x, y: Integer): Integer;
    procedure ShowSolutionThread(IsQlearning: Boolean);
    procedure SarsaThRead;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain      : TfrmMain;    //
  Agente       : rAgente;     // Agente
  qLearning    : TQlearning;  // Q-Learning algorithm
  sarsa        : TQSarsa ;    // Sarsa algorithm
  TSExploration: TTabuSearchExploration;
  EGExploration: TEpsilonGreedyExploration;
  map          : array of array of Integer; // mappa
  mapW,mapH    : Integer;     // dimensioni mappa
  IsStopElab   : Boolean;     // ferma l'apprendimento
  CicliAppren  : Integer ;    // numero di cicli di apprendimento
  FattoreEsplor: Double;      // fattore di esplorazione
  FattoreAppr  : Double  ;    // fattore di apprendimento
  RicompMove   : Double  ;    // ricompensa ricevuta nel caso di movimento
  RicompMuro   : Double  ;    // ricompensa ricevuta nel caso di incontro muro
  RicompObiett : Double;      // ricompensa ricevuta nel caso è arrivato sull'obiettivo

implementation

{$R *.dfm}

procedure TfrmMain.WordSize(x,y: Integer);
begin
     sgCellWord.ColCount        := x;
     sgCellWord.RowCount        := y;
     sgCellWord.DefaultColWidth := Trunc(sgCellWord.Width / sgCellWord.ColCount);
     sgCellWord.DefaultRowHeight:= Trunc(sgCellWord.Height / sgCellWord.RowCount);
     sgCellWord.Options         := [goVertLine,goHorzLine];
     stDim.Caption              := IntToStr(sgCellWord.ColCount)+ ' X '+  IntToStr(sgCellWord.RowCount);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
     CicliAppren  := 100;
     FattoreEsplor:= 0.5;
     FattoreAppr  := 0.5;
     RicompMove   := 0 ;
     RicompMuro   := -1 ;
     RicompObiett := 1;
     IsStopElab   := False;
     ShowSetting;
end;

procedure TfrmMain.ShowSetting;
begin
     edtEsplor.Text := FloatToStr(FattoreEsplor);
     edtAppren.Text := FloatToStr(FattoreAppr);
     edtCicli.Text  := IntToStr(CicliAppren);
     edtRMove.Text  := FloatToStr(RicompMove);
     edtRMuro.Text  := FloatToStr(RicompMuro);
     edtRObiet.Text := FloatToStr(RicompObiett);
end;

procedure TfrmMain.GetSetting;
begin
     FattoreEsplor :=  StrToFloat(edtEsplor.Text);
     FattoreAppr   :=  StrToFloat(edtAppren.Text);
     CicliAppren   :=  StrToInt(edtCicli.Text);
     RicompMove    :=  StrToFloat(edtRMove.Text);
     RicompMuro    :=  StrToFloat(edtRMuro.Text);
     RicompObiett  :=  StrToFloat(edtRObiet.Text);
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
    Loadfile
end;

procedure TfrmMain.btnShowSolClick(Sender: TObject);
begin
    if cbAlgo.ItemIndex = 0 then
      ShowSolutionThread(True)
    else
      ShowSolutionThread(False);
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
     GetSetting;
     ShowSetting;

     stCiclo.Caption := '';

     EGExploration := TEpsilonGreedyExploration.Create( FattoreEsplor );
     TSExploration := TTabuSearchExploration.Create(4,EGExploration);

     case cbAlgo.ItemIndex of
       0 : begin
               qLearning := TQlearning.Create(356, 4, TSExploration );
               QLearningThRead;
           end;
       1 : begin
                sarsa := TQSarsa.Create(356,4,TSExploration);
                SarsaThRead;
           end;
     end;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
    IsStopElab := True;
end;

procedure TfrmMain.QLearningThRead;
var
 numCicli,
 AgenteCorrX,
 AgenteCorrY,
 CurrStato,
 NextStato,
 Azione       : Integer;
 Ricompensa   : Double;
 TabuPol      : TTabuSearchExploration;
 EsplorPol    : TEpsilonGreedyExploration;
begin
    TabuPol    := qLearning.PoliticaEsplor as TTabuSearchExploration;
    EsplorPol  := TabuPol.basePolicy as TEpsilonGreedyExploration ;
    numCicli   := 0;
    IsStopElab := False;
    stCiclo.Caption := '';
    EnableControl(False);

    while (not IsStopElab) and (numCicli < CicliAppren) do
    begin
         EsplorPol.epsilon      := FattoreEsplor - ( numCicli / (CicliAppren) ) * FattoreEsplor;
         qLearning.FattApprend  := FattoreAppr   - ( numCicli / CicliAppren ) * FattoreAppr;
         TabuPol.ResetTabuList;

         AgenteCorrX := Agente.StartX;
         AgenteCorrY := Agente.StartY;

         while ( not IsStopElab ) and ( ( AgenteCorrX <> Agente.StopX ) or ( AgenteCorrY <> Agente.StopY ) )  do
         begin
              CurrStato := GetStateNumber( AgenteCorrX, AgenteCorrY );
              Azione    := qLearning.GetAction( CurrStato );
              Ricompensa:= UpdateAgentPosition(  AgenteCorrX, AgenteCorrY, Azione );
              NextStato := GetStateNumber( AgenteCorrX, AgenteCorrY );
              qLearning.AggiornaStato( CurrStato, Azione, NextStato,Ricompensa );

              TabuPol.SetAzioneTabu(( Azione + 2 ) mod 4, 1);
              Application.ProcessMessages;
         end;

         Inc(numCicli);
         stCiclo.Caption := IntToStr(numCicli);
    end;
    EnableControl(True);

end;

procedure TfrmMain.SarsaThRead;
var
 numCicli,
 AgenteCorrX,
 AgenteCorrY,
 PrecStato,
 PrecAzione,
 NextStato,
 NextAzione   : Integer ;
 Ricompensa   : Double;
 TabuPol      : TTabuSearchExploration;
 EsplorPol    : TEpsilonGreedyExploration;
begin
    TabuPol    := sarsa.PoliticaEsplor as TTabuSearchExploration;
    EsplorPol  := TabuPol.basePolicy as TEpsilonGreedyExploration ;
    numCicli   := 0;
    IsStopElab := False;
    stCiclo.Caption := '';
    EnableControl(False);

    while (not IsStopElab) and (numCicli < CicliAppren) do
    begin
         EsplorPol.epsilon  := FattoreEsplor - ( numCicli / (CicliAppren ) ) * FattoreEsplor;
         sarsa.FattApprend := FattoreAppr    - ( numCicli / CicliAppren )    * FattoreAppr;

         TabuPol.ResetTabuList;

         AgenteCorrX := Agente.StartX;
         AgenteCorrY := Agente.StartY;
         // precedente stato Azione
         PrecStato := GetStateNumber( AgenteCorrX, AgenteCorrY );
         PrecAzione:= sarsa.GetAction( PrecStato );
         // aggiorna l aposizione dell'agente e riceve ricompensa
         Ricompensa:= UpdateAgentPosition(  AgenteCorrX, AgenteCorrY, PrecAzione );

         while ( not IsStopElab ) and ( ( AgenteCorrX <> Agente.StopX ) or ( AgenteCorrY <> Agente.StopY ) )  do
         begin
              // set tabu action
              TabuPol.SetAzioneTabu(( PrecAzione + 2 ) mod 4, 1);
              // preleva  prossimo stato
              NextStato := GetStateNumber( AgenteCorrX, AgenteCorrY );
              // preleva prossima azione
              NextAzione:= sarsa.GetAction( NextStato );
              // facciamo apprendere l'agente - aggiorniamo la Q-function
              sarsa.AggiornaStato( PrecStato, PrecAzione, nextStato, NextAzione,Ricompensa );
              // aggiorna l'agente nella nuova posizione e ricaviamo la ricompensa
              Ricompensa:= UpdateAgentPosition(  AgenteCorrX, AgenteCorrY, NextAzione );

              PrecStato := NextStato;
              PrecAzione:= NextAzione;

              Application.ProcessMessages;
         end;

         if not IsStopElab then
            // aggiorniamo Q-function qundo lo stato terminale è raggiunto
            sarsa.AggiornaStato( PrecStato, PrecAzione, Ricompensa );

         Inc(numCicli);
         stCiclo.Caption := IntToStr(numCicli);
    end;
    EnableControl(True);
end;

procedure TfrmMain.ShowSolutionThread(IsQlearning: Boolean);
var
  TabuPol     : TTabuSearchExploration;
  EsplorPol   : TEpsilonGreedyExploration;
  CurrStato,
  AgenteCorrX,
  AgenteCorrY : Integer;
  Azione      : Integer;
  Ricompensa  : Double;
begin
     IsStopElab := False;

     if IsQlearning then
        TabuPol  := qLearning.PoliticaEsplor as TTabuSearchExploration
     else
        TabuPol  := sarsa.PoliticaEsplor as TTabuSearchExploration;

     EsplorPol := TabuPol.basePolicy as TEpsilonGreedyExploration;

     EsplorPol.Epsilon := 0;
     TabuPol.ResetTabuList;

     // Coordinate correnti dell'agente
     AgenteCorrX := Agente.StartX;
     AgenteCorrY := Agente.StartY;
     EnableControl(False);
     // Ciclo di visualizzazione
     while not IsStopElab do
     begin
          // sleep per rendere evidente il percorso
          Sleep( 200 );

          // Controlla se è arrivato alla meta
          if  ( AgenteCorrX = Agente.StopX ) and ( AgenteCorrY = Agente.StopY ) then
          begin
            // restore the map
            sgCellWord.ColorsTo[Agente.StartX,Agente.StartY] := clBlack;
            sgCellWord.ColorsTo[Agente.StopX,Agente.StopY] := clRed;

            AgenteCorrX := Agente.StartX;
            AgenteCorrY := Agente.StartY;

            Sleep( 200 );
          end;

           // Rimuove l'agente dalla posizione corrente
            sgCellWord.ColorsTo[AgenteCorrX, AgenteCorrY] := clWhite;

           // preleva lo stato corrente dell'agente
           CurrStato := GetStateNumber( AgenteCorrX, AgenteCorrY );
           // preleva l'azione per lo stato corrente
           if IsQlearning then
               Azione := qLearning.GetAction( CurrStato )
           else
               Azione  := sarsa.GetAction( CurrStato );
           // aggiorna l'agente nella nuova posizione e ricaviamo la ricompensa
           Ricompensa := UpdateAgentPosition( AgenteCorrX, AgenteCorrY, Azione );

           // posiziona l'agente nella nuova posizione
           sgCellWord.ColorsTo[AgenteCorrX, AgenteCorrY] := clBlack;
           Application.ProcessMessages;
     end;
     sgCellWord.ColorsTo[AgenteCorrX, AgenteCorrY]   := clWhite;
     sgCellWord.ColorsTo[Agente.StartX,Agente.StartY]:= clBlack;
     sgCellWord.ColorsTo[Agente.StopX,Agente.StopY]  := clRed;
     EnableControl( true );

end;

// Aggiorna la posizione dell'agente e rirorna la ricompensa
function TfrmMain.UpdateAgentPosition(var currentX,currentY: Integer; const action: Integer): Double;
var
 Ricompensa : Double;
 dx,dy,newX,newY : Integer;
begin
     // ricompensa di dafault uguale alla ricompensa per il movimento
     Ricompensa := RicompMove;
     // direzione del movimento
     dx := 0;
     dy := 0;

     case action of
        0: dy := -1; // va a nord (up)
        1: dx := 1;  // va a est (right)
        2: dy := 1;  // va a sud (down)
        3: dx := -1; // va a ovest(left)
     end;

     newX := currentX + dx;
     newY := currentY + dy;

     // Verifica le nuove coordinate dell'agente
     if ( map[newX,newY] <> 0 ) or ( newX < 0 ) or
        ( newX >= mapW ) or ( newY < 0 ) or ( newY >= mapH ) then
             // we found a wall or got outside of the world
             Ricompensa := RicompMuro
     else begin
          currentX := newX;
          currentY := newY;

          // Controlla se è arrivato all'obiettivo
          if ( currentX = Agente.StopX ) and ( currentY = Agente.StopY ) then
                Ricompensa := RicompObiett;
     end;
     Result := Ricompensa;

end;

function TfrmMain.GetStateNumber( x, y:Integer ): Integer;

begin
    Result := (y + ( (sgCellWord.ColCount - 1) * y ) )+x;
    Exit;
end;

procedure TfrmMain.EnableControl(lEnable: Boolean);
begin
     btnLoad.Enabled   := lEnable;

     cbAlgo.Enabled    := lEnable;
     edtEsplor.Enabled := lEnable;
     edtAppren.Enabled := lEnable;
     edtCicli.Enabled  := lEnable;

     edtRMuro.Enabled  := lEnable;
     edtRMove.Enabled  := lEnable;
     edtRObiet.Enabled := lEnable;

     btnStart.Enabled  := lEnable;
     btnShowSol.Enabled:= lEnable;
     btnStop.Enabled   := not lEnable;
end;

procedure TfrmMain.Loadfile;
var
 txtFile   : TextFile;
 Linee,j,i : Integer;
 strLinea  : string;
 ListStr   : TStringList;
begin
    dlgOpen.Title      := 'Carica File Dati';
    dlgOpen.InitialDir := ExtractFilePath(Application.ExeName)+ 'Dati';
    dlgOpen.DefaultExt := 'Map';
    dlgOpen.Filter     := 'Map files (*.Map)|*.MAP';
    if dlgOpen.Execute then
    begin
         sgCellWord.ClearAll;
         sgCellWord.ColCount :=1;
         sgCellWord.RowCount := 1;
         ListStr := TStringList.Create ;
      try
         AssignFile(txtFile,dlgOpen.FileName);
         Reset(txtFile);
         Linee := 0;
         mapW  := 0;
         mapH  := 0;
         j     := 0;
         while not Eof(txtFile) do
         begin
              // legge le linee del file
              Readln(txtFile,strLinea);
              // elimina spazi eventuali
              strLinea := Trim(strLinea);
              // spitta la linea in una stringlist
              Split(' ',strLinea,ListStr);
              if (strLinea = '') or (ListStr[0] = '') or (ListStr[0] = ';') then
                 Continue;

              case Linee of
                // se è la 1° linea stabilisce le dimensioni della griglia
                0: begin
                        mapW := StrToInt(ListStr[0]);
                        mapH := StrToInt(ListStr[1]);
                        SetLength(map,mapW,mapH);
                        WordSize(mapW,mapH);
                   end;
                // accetta solo un'agente
                1: begin
                        if StrToInt(ListStr[0]) <> 1 then
                        begin
                             ShowMessage('Supporta solo un''Agente');
                             Exit;
                        end;
                   end;
                 // posizione iniziale efinale dell'agente
                2: begin
                       Agente.StartX := StrToInt(ListStr[0]);
                       Agente.StartY := StrToInt(ListStr[1]);
                       Agente.StopX  := StrToInt(ListStr[2]);
                       Agente.StopY  := StrToInt(ListStr[3]);
                       // verifica che sia entro i limiti della griglia
                       if ( Agente.StartX < 0 ) or ( Agente.StartX >= mapW ) or
                          ( Agente.StartY < 0 ) or ( Agente.StartY >= mapH ) or
                          ( Agente.StopX < 0 )  or ( Agente.StopX >= mapW ) or
                          ( Agente.StopY < 0 ) or  ( Agente.StopY >= mapH )  then
                       begin
                            ShowMessage('Posizione dell''Agente fuori dai limiti');
                            Exit;
                       end;
                   end;
                 // riempie l'array map con i valori
                 else begin
                       if j < mapH then
                       begin
                            for i := 0 to mapW - 1 do
                            begin
                               map[i,j] := StrToInt(ListStr[i]);
                               if map[i,j] > 1 then
                                  map[i,j] := 1;
                            end;
                            Inc(j);
                       end;

                 end;
              end;   // end case
              inc(linee);
         end; // end while

         // trsferisce i valori alla griglia
         for j := 0 to mapH -1 do
            for i := 0 to mapW - 1 do
               if map[i,j] = 1 then
                 sgCellWord.ColorsTo[i,j] := clGreen;

         // posizione iniziale e finale dell'agente
         sgCellWord.ColorsTo[Agente.StartX,Agente.StartY] := clBlack;
         sgCellWord.ColorsTo[Agente.StopX,Agente.StopY] := clRed;
         btnStart.Enabled := True;
      finally
         ListStr.Free;
         CloseFile(txtFile);
      end;
    end;

end;

procedure TfrmMain.Split(const Delimiter: Char; Input: string; const Strings: TStrings) ;
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;


end.
