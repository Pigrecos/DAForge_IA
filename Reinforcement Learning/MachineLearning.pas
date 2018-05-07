// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//

unit MachineLearning;

interface

uses
  Windows, Messages, SysUtils, Classes,Math;


Type
  aDouble = array  of Double;
  /// <summary>
  /// Exploration policy interface.
  /// </summary>
  ///
  /// <remarks>The interface describes exploration policies, which are used in Reinforcement
  /// Learning to explore state space.</remarks>
  ///
  IExplorationPolicy =  interface
   ['{5E48D0F6-DC24-4E93-83AE-C35BE63E99C8}']

    //// <summary>
    /// Choose an action.
    /// </summary>
    ///
    /// <param name="actionEstimates">Action estimates.</param>
    ///
    /// <returns>Returns selected action.</returns>
    ///
    /// <remarks>The method chooses an action depending on the provided estimates. The
    /// estimates can be any sort of estimate, which values usefulness of the action
    /// (expected summary reward, discounted reward, etc).</remarks>
    ///
    function  SelezAzione(const Azioni: array of Double): Integer;
  End;

  /// <summary>
  /// Boltzmann distribution exploration policy.
  /// </summary>
  ///
  /// <remarks><para>The class implements exploration policy base on Boltzmann distribution.
  /// Acording to the policy, action <b>a</b> at state <b>s</b> is selected with the next probability:</para>
  /// <code lang="none">
  ///                   exp( Q( s, a ) / t )
  /// p( s, a ) = -----------------------------
  ///              SUM( exp( Q( s, b ) / t ) )
  ///               b
  /// </code>
  /// <para>where <b>Q(s, a)</b> is action's <b>a</b> estimation (usefulness) at state <b>s</b> and
  /// <b>t</b> is <see cref="Temperature"/>.</para>
  /// </remarks>
  ///
  /// <seealso cref="RouletteWheelExploration"/>
  /// <seealso cref="EpsilonGreedyExploration"/>
  /// <seealso cref="TabuSearchExploration"/>
  ///
  TBoltzmannEsploraz = class(TInterfacedObject,IExplorationPolicy)
  private
    FTemperatura : Double;  // parametro per bolzamm distibution
    procedure SetTemperatura(const Value: Double);
  public
    constructor Create(dTemp: Double);
    function    SelezAzione(const Azioni: array of Double):Integer;
    /// <summary>
    /// Termperature parameter of Boltzmann distribution, >0.
    /// </summary>
    ///
    /// <remarks><para>The property sets the balance between exploration and greedy actions.
    /// If temperature is low, then the policy tends to be more greedy.</para></remarks>
    ///
    property Temperatura : Double read FTemperatura write SetTemperatura ;
  end;

  /// <summary>
  /// Epsilon greedy exploration policy.
  /// </summary>
  ///
  /// <remarks><para>The class implements epsilon greedy exploration policy. Acording to the policy,
  /// the best action is chosen with probability <b>1-epsilon</b>. Otherwise,
  /// with probability <b>epsilon</b>, any other action, except the best one, is
  /// chosen randomly.</para>
  ///
  /// <para>According to the policy, the epsilon value is known also as exploration rate.</para>
  /// </remarks>
  ///
  /// <seealso cref="RouletteWheelExploration"/>
  /// <seealso cref="BoltzmannExploration"/>
  /// <seealso cref="TabuSearchExploration"/>
  ///
  TEpsilonGreedyExploration = class(TInterfacedObject,IExplorationPolicy)
  private
    Fepsilon  : Double; // fattore di esplorazione
    procedure SetEpsilon(const Value: Double);
  public
    constructor Create(depsilon: Double);
    function    SelezAzione(const Azioni: array of Double):Integer;
    /// <summary>
    /// Epsilon value (exploration rate), [0, 1].
    /// </summary>
    ///
    /// <remarks><para>The value determines the amount of exploration driven by the policy.
    /// If the value is high, then the policy drives more to exploration - choosing random
    /// action, which excludes the best one. If the value is low, then the policy is more
    /// greedy - choosing the beat so far action.
    /// </para></remarks>
    ///
    property epsilon: Double read Fepsilon write SetEpsilon ;
  end;

  /// <summary>
  /// Roulette wheel exploration policy.
  /// </summary>
  ///
  /// <remarks><para>The class implements roulette whell exploration policy. Acording to the policy,
  /// action <b>a</b> at state <b>s</b> is selected with the next probability:</para>
  /// <code lang="none">
  ///                   Q( s, a )
  /// p( s, a ) = ------------------
  ///              SUM( Q( s, b ) )
  ///               b
  /// </code>
  /// <para>where <b>Q(s, a)</b> is action's <b>a</b> estimation (usefulness) at state <b>s</b>.</para>
  ///
  /// <para><note>The exploration policy may be applied only in cases, when action estimates (usefulness)
  /// are represented with positive value greater then 0.</note></para>
  /// </remarks>
  ///
  /// <seealso cref="BoltzmannExploration"/>
  /// <seealso cref="EpsilonGreedyExploration"/>
  /// <seealso cref="TabuSearchExploration"/>
  ///
  TRouletteWheelExploration = class(TInterfacedObject,IExplorationPolicy)
  public
    constructor Create;
    function    SelezAzione(const Azioni: array of Double):Integer;

  end;

  /// <summary>
  /// Tabu search exploration policy.
  /// </summary>
  ///
  /// <remarks>The class implements simple tabu search exploration policy,
  /// allowing to set certain actions as tabu for a specified amount of
  /// iterations. The actual exploration and choosing from non-tabu actions
  /// is done by <see cref="BasePolicy">base exploration policy</see>.</remarks>
  ///
  /// <seealso cref="BoltzmannExploration"/>
  /// <seealso cref="EpsilonGreedyExploration"/>
  /// <seealso cref="RouletteWheelExploration"/>
  ///
  TTabuSearchExploration = class(TInterfacedObject,IExplorationPolicy)
  private
    FAzioni     : Integer;          // total actions count
    FtabuAzioni : array of Integer; // list of tabu actions
    FbasePolicy : IExplorationPolicy;  // base exploration policy

  public
    constructor Create(dactions : Integer; dbasePolicy : IExplorationPolicy);
    function    SelezAzione(const Azioni: array of Double):Integer;
    procedure   ResetTabuList;
    procedure   SetAzioneTabu( pAzione, tabuTime: Integer );
    /// <summary>
    /// Base exploration policy.
    /// </summary>
    ///
    /// <remarks>Base exploration policy is the policy, which is used
    /// to choose from non-tabu actions.</remarks>
    ///
    property basePolicy: IExplorationPolicy read FbasePolicy write FbasePolicy ;
  end;

  /// <summary>
	/// QLearning learning algorithm.
	/// </summary>
  ///
  /// <remarks>The class provides implementation of Q-Learning algorithm, known as
  /// off-policy Temporal Difference control.</remarks>
  ///
  /// <seealso cref="Sarsa"/>
  ///
  TQlearning = class
  private
    FStati         : Integer;              	  // Numero di stati possibili
	  FAzioni        : Integer;                 // Numero di possibili azioni
    Fqvalues       : array of array of Double;// q-values
    FPolicyEsploraz: IExplorationPolicy;         // Politica di esplorazione
    FFattSconto    : Double;            	    // Fattore di sconto
	  FFattApprend   : Double;                  // Fattore di apprendimento
    procedure SetFattoreSconto(const Value: Double);
    procedure SetFattoreAppr(const Value: Double);
  public
    constructor Create(Stati, Azioni: Integer;PolEsplorazione: IExplorationPolicy; IsRandomize: Boolean= True);
    function    GetAction( stato: Integer ):Integer;
    procedure   AggiornaStato( PrecStato, Azione, nextStato: Integer;Ricomp: Double );
    /// <summary>
    /// Amount of possible states.
    /// </summary>
    ///
    property StatiCount     : Integer read FStati;
    /// <summary>
    /// Amount of possible actions.
    /// </summary>
    ///
    property AzioniCount    : Integer read FAzioni;
    /// <summary>
    /// Exploration policy.
    /// </summary>
    ///
    /// <remarks>Policy, which is used to select actions.</remarks>
    ///
    property PoliticaEsplor : IExplorationPolicy read FPolicyEsploraz write FPolicyEsploraz;
    /// <summary>
    /// Learning rate, [0, 1].
    /// </summary>
    ///
    /// <remarks>The value determines the amount of updates Q-function receives
    /// during learning. The greater the value, the more updates the function receives.
    /// The lower the value, the less updates it receives.</remarks>
    ///
    property FattApprend    : Double read FFattApprend write SetFattoreAppr;
    /// <summary>
    /// Discount factor, [0, 1].
    /// </summary>
    ///
    /// <remarks>Discount factor for the expected summary reward. The value serves as
    /// multiplier for the expected reward. So if the value is set to 1,
    /// then the expected summary reward is not discounted. If the value is getting
    /// smaller, then smaller amount of the expected reward is used for actions'
    /// estimates update.</remarks>
    ///
    property FattSconto     : Double read FFattSconto write SetFattoreSconto;
  end;

  /// <summary>
  /// Sarsa learning algorithm.
  /// </summary>
  ///
  /// <remarks>The class provides implementation of Sarse algorithm, known as
  /// on-policy Temporal Difference control.</remarks>
  ///
  /// <seealso cref="QLearning"/>
  ///
  TQSarsa = class
  private
    FStati         : Integer;              	  // Numero di stati possibili
	  FAzioni        : Integer;                 // Numero di possibili azioni
    Fqvalues       : array of array of Double;// q-values
    FPolicyEsploraz: IExplorationPolicy;         // Politica di esplorazione
    FFattSconto    : Double;            	    // Fattore di sconto
	  FFattApprend   : Double;                  // Fattore di apprendimento
    procedure SetFattoreSconto(const Value: Double);
    procedure SetFattoreAppr(const Value: Double);
  public
    constructor Create(Stati, Azioni: Integer;PolEsplorazione: IExplorationPolicy; IsRandomize: Boolean= True);
    function    GetAction( stato: Integer ):Integer;
    
    procedure   AggiornaStato( PrecStato, PrecAzione, nextStato, nextAzione: Integer; Ricomp: Double );overload;
    procedure   AggiornaStato( precStato, precAzione: Integer; Ricomp: Double );overload;
    /// <summary>
    /// Amount of possible states.
    /// </summary>
    ///
    property StatiCount     : Integer read FStati;
    /// <summary>
    /// Amount of possible actions.
    /// </summary>
    ///
    property AzioniCount    : Integer read FAzioni;
    /// <summary>
    /// Exploration policy.
    /// </summary>
    ///
    /// <remarks>Policy, which is used to select actions.</remarks>
    ///
    property PoliticaEsplor : IExplorationPolicy read FPolicyEsploraz write FPolicyEsploraz;
    /// <summary>
    /// Learning rate, [0, 1].
    /// </summary>
    ///
    /// <remarks>The value determines the amount of updates Q-function receives
    /// during learning. The greater the value, the more updates the function receives.
    /// The lower the value, the less updates it receives.</remarks>
    ///
    property FattApprend    : Double read FFattApprend write SetFattoreAppr;
    /// <summary>
    /// Discount factor, [0, 1].
    /// </summary>
    ///
    /// <remarks>Discount factor for the expected summary reward. The value serves as
    /// multiplier for the expected reward. So if the value is set to 1,
    /// then the expected summary reward is not discounted. If the value is getting
    /// smaller, then smaller amount of the expected reward is used for actions'
    /// estimates update.</remarks>
    ///
    property FattSconto     : Double read FFattSconto write SetFattoreSconto;
  end;

  implementation


{ BoltzmannEsploraz }

/// <summary>
/// Initializes a new instance of the <see cref="BoltzmannExploration"/> class.
/// </summary>
///
/// <param name="temperature">Termperature parameter of Boltzmann distribution.</param>
///
constructor TBoltzmannEsploraz.Create(dTemp: Double);
begin
   Randomize;
   FTemperatura := dTemp ;
end;

/// <summary>
/// Choose an action.
/// </summary>
///
/// <param name="actionEstimates">Action estimates.</param>
///
/// <returns>Returns selected action.</returns>
///
/// <remarks>The method chooses an action depending on the provided estimates. The
/// estimates can be any sort of estimate, which values usefulness of the action
/// (expected summary reward, discounted reward, etc).</remarks>
///
function TBoltzmannEsploraz.SelezAzione(const Azioni: array of Double ): Integer;
var
 actionsCount,
 i,
 greedyAction        : Integer;
 actionProbabilities : array of Double;
 Sum,
 probabilitiesSum,
 actionProbability,
 actionRandomNumber,
 maxReward           : Double;
 begin
      // Numero di azioni
      actionsCount := Length(Azioni);
      // probilità azioni
      SetLength(actionProbabilities,actionsCount);
      // somma azioni
      sum              := 0;
      probabilitiesSum := 0;

      for  i := 0 to actionsCount -1 do
      begin
           actionProbability := Exp( Azioni[i] / FTemperatura );
           actionProbabilities[i] := actionProbability;
           probabilitiesSum       := probabilitiesSum + actionProbability;
      end;

      if (IsInfinite( probabilitiesSum ) ) or ( probabilitiesSum = 0 ) then
      begin
           // do greedy selection in the case of infinity or zero
           maxReward    := Azioni[0];
           greedyAction := 0;

           for i := 1 to actionsCount - 1 do
           begin
                if Azioni[i] > maxReward then
                begin
                     maxReward    := Azioni[i];
                     greedyAction := i;
                end;
           end;
           Result := greedyAction;
           Exit;
      end;

      // preleva un numero casuale per determinare la scelta dell'azione
      actionRandomNumber := Random;

      for  i := 0 to actionsCount -1 do
      begin
           sum := Sum + (actionProbabilities[i] / probabilitiesSum);
           if actionRandomNumber <= sum then
           begin
                Result := i;
                Exit;
           end;
      end;

      Result := actionsCount - 1;
 end;

procedure TBoltzmannEsploraz.SetTemperatura(const Value: Double);
begin
  FTemperatura := Value;
end;

{ TEpsilonGreedyExploration }

/// <summary>
/// Initializes a new instance of the <see cref="EpsilonGreedyExploration"/> class.
/// </summary>
///
/// <param name="epsilon">Epsilon value (exploration rate).</param>
///
constructor TEpsilonGreedyExploration.Create(depsilon: Double);
begin
   Randomize;
   Fepsilon := depsilon;
end;

/// <summary>
/// Choose an action.
/// </summary>
///
/// <param name="actionEstimates">Action estimates.</param>
///
/// <returns>Returns selected action.</returns>
///
/// <remarks>The method chooses an action depending on the provided estimates. The
/// estimates can be any sort of estimate, which values usefulness of the action
/// (expected summary reward, discounted reward, etc).</remarks>
///
function TEpsilonGreedyExploration.SelezAzione(const Azioni: array of Double): Integer;
var
 AzioniCount,
 i,
 AzioneGreedy ,
 AzioneRandom      : Integer;
 maxRicomp,numRand : Double;
begin

     // Numero azioni
     AzioniCount := Length(Azioni);

     // Trova la migliore azione (greedy)
     maxRicomp    := Azioni[0];
     AzioneGreedy := 0;
     for i := 1 to AzioniCount - 1 do
     begin
          if Azioni[i] > maxRicomp then
          begin
               maxRicomp    := Azioni[i];
               AzioneGreedy := i;
          end;
     end;

     Randomize;
     //Inizia l'esplorazione
     numRand := Random   ;
     if numRand < Fepsilon  then
     begin
          AzioneRandom := Random( AzioniCount -1 );
          if ( AzioneRandom >= AzioneGreedy ) then
             Inc(AzioneRandom);
          Result :=  AzioneRandom;
          Exit;
     end;

     Result :=  AzioneGreedy;
end;

procedure TEpsilonGreedyExploration.SetEpsilon(const Value: Double);
begin
  Fepsilon := Value ;
end;


{ TRouletteWheelExploration }

/// <summary>
/// Initializes a new instance of the <see cref="RouletteWheelExploration"/> class.
/// </summary>
///
constructor TRouletteWheelExploration.Create;
begin
    Randomize;
end;

/// <summary>
/// Choose an action.
/// </summary>
///
/// <param name="actionEstimates">Action estimates.</param>
///
/// <returns>Returns selected action.</returns>
///
/// <remarks>The method chooses an action depending on the provided estimates. The
/// estimates can be any sort of estimate, which values usefulness of the action
/// (expected summary reward, discounted reward, etc).</remarks>
///
function TRouletteWheelExploration.SelezAzione(const Azioni: array of Double): Integer;
var
 AzioniCount,i   : Integer;
 Somma,
 StimaSomma,
 NumeroAzioneRand: Double;
begin
     Randomize;
     // Numero azioni
     AzioniCount:= Length(Azioni);
     // Somma azioni
     Somma      := 0;
     StimaSomma := 0;

     for i := 0 to AzioniCount -1 do
        StimaSomma :=  StimaSomma + Azioni[i];

      // preleva un numero casuale per determinare la scelta dell'azione
      NumeroAzioneRand := Random;

      for  i := 0 to  AzioniCount - 1 do
      begin
           Somma := Somma + (Azioni[i] / StimaSomma);
           if NumeroAzioneRand <= Somma then
           begin
                Result := i;
                Exit;
           end;
      end;

      Result :=  AzioniCount - 1;

end;

{ TTabuSearchExploration }

/// <summary>
/// Initializes a new instance of the <see cref="TabuSearchExploration"/> class.
/// </summary>
///
/// <param name="actions">Total actions count.</param>
/// <param name="basePolicy">Base exploration policy.</param>
///
constructor TTabuSearchExploration.Create(dactions: Integer;dbasePolicy: IExplorationPolicy);
begin
    FAzioni     := dactions;
    FbasePolicy := dbasePolicy;
    SetLength(FtabuAzioni,FAzioni);
end;

/// <summary>
/// Choose an action.
/// </summary>
///
/// <param name="actionEstimates">Action estimates.</param>
///
/// <returns>Returns selected action.</returns>
///
/// <remarks>The method chooses an action depending on the provided estimates. The
/// estimates can be any sort of estimate, which values usefulness of the action
/// (expected summary reward, discounted reward, etc). The action is choosed from
/// non-tabu actions only.</remarks>
///
function TTabuSearchExploration.SelezAzione(const Azioni: array of Double): Integer;
var
   nonTabuAzioni,
   i,j             : Integer;
   StimeAzioniPerm : array of Double;
   MapAzioniPerm   : array of Integer;
begin
     // preleva il numero di non-tabu actions
     nonTabuAzioni := FAzioni;
     for i := 0 to FAzioni - 1 do
     begin
           if FtabuAzioni[i] <> 0 then
              Dec(nonTabuAzioni);
     end;

     // Azione permesse
     SetLength(StimeAzioniPerm,nonTabuAzioni);
     SetLength(MapAzioniPerm,nonTabuAzioni);

     j := 0;
     for i := 0 to FAzioni - 1 do
     begin
          if  FtabuAzioni[i] = 0 then
          begin
                // azioni permesse
                StimeAzioniPerm[j] := Azioni[i];
                MapAzioniPerm[j] := i;
                Inc(j);
          end
          else
               // decrementa tabu time di tabu action
               Dec(FtabuAzioni[i]);
     end;

     Result := MapAzioniPerm[basePolicy.SelezAzione( StimeAzioniPerm )]; ;

end;

/// <summary>
/// Reset tabu list.
/// </summary>
///
/// <remarks>Clears tabu list making all actions allowed.</remarks>
///
procedure TTabuSearchExploration.ResetTabuList;
var
 i : Integer;
begin
    for i := 0 to FAzioni -1  do
      FtabuAzioni[i] := 0;

end;

/// <summary>
/// Set tabu action.
/// </summary>
///
/// <param name="action">Action to set tabu for.</param>
/// <param name="tabuTime">Tabu time in iterations.</param>
///
procedure TTabuSearchExploration.SetAzioneTabu(pAzione, tabuTime: Integer);
begin
     FtabuAzioni[pAzione] := tabuTime;
end;

{ TQlearning }

/// <summary>
/// Initializes a new instance of the <see cref="QLearning"/> class.
/// </summary>
///
/// <param name="states">Amount of possible states.</param>
/// <param name="actions">Amount of possible actions.</param>
/// <param name="explorationPolicy">Exploration policy.</param>
/// <param name="randomize">Randomize action estimates or not.</param>
///
/// <remarks>The <b>randomize</b> parameter specifies if initial action estimates should be randomized
/// with small values or not. Randomization of action values may be useful, when greedy exploration
/// policies are used. In this case randomization ensures that actions of the same type are not chosen always.</remarks>
///
constructor TQlearning.Create(Stati, Azioni: Integer;PolEsplorazione: IExplorationPolicy; IsRandomize: Boolean= True);
var
 i,j : Integer;
begin
     FStati         := Stati;
     FAzioni        := Azioni;
     FPolicyEsploraz:= PolEsplorazione;
     FFattSconto    := 0.95;
     FFattApprend   := 0.25;

     // crea Q-array
     SetLength(Fqvalues,Stati);
     for i := 0 to Stati - 1 do
       SetLength(Fqvalues[i],Azioni);

     // do randomization
     if IsRandomize then
     begin
          RandSeed := GetTickCount;
          for i := 0 to Stati - 1 do
          begin
               for j := 0 to Azioni - 1 do
                  Fqvalues[i][j] := Random ;
          end;

     end;
end;

/// <summary>
/// Get next action from the specified state.
/// </summary>
///
/// <param name="state">Current state to get an action for.</param>
///
/// <returns>Returns the action for the state.</returns>
///
/// <remarks>The method returns an action according to current
/// <see cref="ExplorationPolicy">exploration policy</see>.</remarks>
///
function TQlearning.GetAction(stato: Integer): Integer;
begin
     Result := FPolicyEsploraz.SelezAzione(Fqvalues[stato])
end;

procedure TQlearning.SetFattoreSconto(const Value: Double);
begin
     FFattSconto := Value ;
end;

procedure TQlearning.SetFattoreAppr(const Value: Double);
begin
     FFattApprend := Value;
end;

// <summary>
/// Update Q-function's value for the previous state-action pair.
/// </summary>
///
/// <param name="previousState">Previous state.</param>
/// <param name="action">Action, which leads from previous to the next state.</param>
/// <param name="reward">Reward value, received by taking specified action from previous state.</param>
/// <param name="nextState">Next state.</param>
///
procedure TQlearning.AggiornaStato(PrecStato, Azione, nextStato: Integer; Ricomp: Double);
var
  nextStimaAzione,
  precStimaAzione      : ^aDouble;
  maxNextRicompAttesa  : Double;
  i                    : Integer;

begin
     // stima prossima azione
     nextStimaAzione := @(Fqvalues[nextStato]);

		 // ricerca la ricompensa massima per il prossimo stato
     maxNextRicompAttesa := nextStimaAzione^[0];

		 for i := 1 to FAzioni -1  do
		 begin
          if nextStimaAzione^[i] > maxNextRicompAttesa  then
				      maxNextRicompAttesa := nextStimaAzione^[i] ;
     end;

     // Stima precedente azione
     precStimaAzione := @(Fqvalues[PrecStato]);

     // aggiorna la stima della precedente azione nel precedente stato
     precStimaAzione^[Azione] := precStimaAzione^[Azione] * ( 1.0 - FFattApprend );
     precStimaAzione^[Azione] := precStimaAzione^[Azione] +
        ( FFattApprend * ( Ricomp + FFattSconto *  maxNextRicompAttesa ) );

end;

{ TQSarsa }

/// <summary>
/// Initializes a new instance of the <see cref="Sarsa"/> class.
/// </summary>
///
/// <param name="states">Amount of possible states.</param>
/// <param name="actions">Amount of possible actions.</param>
/// <param name="explorationPolicy">Exploration policy.</param>
/// <param name="randomize">Randomize action estimates or not.</param>
///
/// <remarks>The <b>randomize</b> parameter specifies if initial action estimates should be randomized
/// with small values or not. Randomization of action values may be useful, when greedy exploration
/// policies are used. In this case randomization ensures that actions of the same type are not chosen always.</remarks>
///
constructor TQSarsa.Create(Stati, Azioni: Integer;PolEsplorazione: IExplorationPolicy; IsRandomize: Boolean= True);
var
 i,j : Integer;
begin
     FStati          := Stati;
     FAzioni         := Azioni;
     FPolicyEsploraz := PolEsplorazione;
     FFattSconto     := 0.95;
     FFattApprend    := 0.25;

     // crea Q-array
     SetLength(Fqvalues,Stati);
     for i := 0 to Stati - 1 do
       SetLength(Fqvalues[i],Azioni);

     // do randomization
     if IsRandomize then
     begin
          Randomize;
          for i := 0 to Stati - 1 do
          begin
               for j := 0 to Azioni - 1 do
                  Fqvalues[i][j] := Random ;
          end;

     end;
end;

/// <summary>
/// Get next action from the specified state.
/// </summary>
///
/// <param name="state">Current state to get an action for.</param>
///
/// <returns>Returns the action for the state.</returns>
///
/// <remarks>The method returns an action according to current
/// <see cref="ExplorationPolicy">exploration policy</see>.</remarks>
///
function TQSarsa.GetAction(stato: Integer): Integer;
begin
     Result := FPolicyEsploraz.SelezAzione(Fqvalues[stato])
end;

procedure TQSarsa.SetFattoreSconto(const Value: Double);
begin
    FFattSconto := Max( 0.0, Min( 1.0, Value ) );
end;

procedure TQSarsa.SetFattoreAppr(const Value: Double);
begin
     FFattApprend := Max( 0.0, Min( 1.0, Value ) );
end;

/// <summary>
/// Update Q-function's value for the previous state-action pair.
/// </summary>
///
/// <param name="previousState">Curren state.</param>
/// <param name="previousAction">Action, which lead from previous to the next state.</param>
/// <param name="reward">Reward value, received by taking specified action from previous state.</param>
///
/// <remarks>Updates Q-function's value for the previous state-action pair in
/// the case if the next state is terminal.</remarks>
///
procedure TQSarsa.AggiornaStato(precStato, precAzione: Integer; Ricomp: Double);
var
  PrecStimeAzione : PDouble;
begin
     // Stima precedente stato-Azione
     PrecStimeAzione := @Fqvalues[precStato][precAzione];

     // aggiorna ricompensa massima per il precedente stato
     PrecStimeAzione^ := PrecStimeAzione^ * ( 1.0 - FFattApprend );
     PrecStimeAzione^ := PrecStimeAzione^ + ( FFattApprend * Ricomp );

end;

/// <summary>
/// Update Q-function's value for the previous state-action pair.
/// </summary>
///
/// <param name="previousState">Curren state.</param>
/// <param name="previousAction">Action, which lead from previous to the next state.</param>
/// <param name="reward">Reward value, received by taking specified action from previous state.</param>
/// <param name="nextState">Next state.</param>
/// <param name="nextAction">Next action.</param>
///
/// <remarks>Updates Q-function's value for the previous state-action pair in
/// the case if the next state is non terminal.</remarks>
///
procedure TQSarsa.AggiornaStato(PrecStato, PrecAzione, nextStato, nextAzione: Integer; Ricomp: Double);
var
  precStimeAzione : PDouble;
begin
     precStimeAzione := @Fqvalues[PrecStato][PrecAzione];

     // aggiorna ricompensa massima per il precedente stato
     precStimeAzione^ := precStimeAzione^ * ( 1.0 - FFattApprend ) ;
     precStimeAzione^ := precStimeAzione^ +  ( FFattApprend *
                   ( Ricomp + FFattSconto * Fqvalues[nextStato][nextAzione] ) );

end;

end.
