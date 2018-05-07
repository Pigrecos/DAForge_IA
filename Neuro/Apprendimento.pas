// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit Apprendimento;

interface
uses
  Windows, Messages, SysUtils, Classes,System.Math,
  Neuron,FunzAttivazione,Layer,Network,NeuralNetDef;

type

  /// <summary>
  /// Supervised learning interface.
  /// </summary>
  ///
  /// <remarks><para>The interface describes methods, which should be implemented
  /// by all supervised learning algorithms. Supervised learning is such
  /// type of learning algorithms, where system's desired output is known on
  /// the learning stage. So, given sample input values and desired outputs,
  /// system should adopt its internals to produce correct (or close to correct)
  /// result after the learning step is complete.</para></remarks>
  ///
  ISupervisedLearning = interface
      ['{8B407372-E83C-4132-AE90-42F2FD27ECE8}']

      /// <summary>
      /// Runs learning iteration.
      /// </summary>
      ///
      /// <param name="input">Input vector.</param>
      /// <param name="output">Desired output vector.</param>
      ///
      /// <returns>Returns learning error.</returns>
      ///
      function Run( Input, Output: ADouble ):Double;

      
      ///	<summary>
      ///	  Esecuzione Cicli di Apprendimento.
      ///	</summary>
      ///	<param name="input">
      ///	  Array di vettori di  input.
      ///	</param>
      ///	<param name="output">
      ///	  Array di vettori di output.
      ///	</param>
      ///	<returns>
      ///	  Ritorna la somma dell'errore durante l'apprendimento.
      ///	</returns>
      
      function RunEpoch( Input, Output:AADouble):Double;
  end;

  /// <summary>
  /// Unsupervised learning interface.
  /// </summary>
  ///
  /// <remarks><para>The interface describes methods, which should be implemented
  /// by all unsupervised learning algorithms. Unsupervised learning is such
  /// type of learning algorithms, where system's desired output is not known on
  /// the learning stage. Given sample input values, it is expected, that
  /// system will organize itself in the way to find similarities betweed provided
  /// samples.</para></remarks>
  ///
  IUnsupervisedLearning = interface
      ['{D79C949D-33E6-4B14-A989-3B88C97E4D67}']
      /// <summary>
      /// Runs learning iteration.
      /// </summary>
      ///
      /// <param name="input">Input vector.</param>
      ///
      /// <returns>Returns learning error.</returns>
      ///
      function Run( Input: ADouble ):Double;

      /// <summary>
      /// Runs learning epoch.
      /// </summary>
      ///
      /// <param name="input">Array of input vectors.</param>
      ///
      /// <returns>Returns sum of learning errors.</returns>
      ///
      function RunEpoch( Input:AADouble):Double;
  end;

  /// <summary>
  /// Back propagation learning algorithm.
  /// </summary>
  ///
  /// <remarks><para>The class implements back propagation learning algorithm,
  /// which is widely used for training multi-layer neural networks with
  /// continuous activation functions.</para>
  ///
  /// <para>Sample usage (training network to calculate XOR function):</para>
  /// <code>
  /// // initialize input and output values
  /// double[][] input = new double[4][] {
  ///     new double[] {0, 0}, new double[] {0, 1},
  ///     new double[] {1, 0}, new double[] {1, 1}
  /// };
  /// double[][] output = new double[4][] {
  ///     new double[] {0}, new double[] {1},
  ///     new double[] {1}, new double[] {0}
  /// };
  /// // create neural network
  /// ActivationNetwork   network = new ActivationNetwork(
  ///     SigmoidFunction( 2 ),
  ///     2, // two inputs in the network
  ///     2, // two neurons in the first layer
  ///     1 ); // one neuron in the second layer
  /// // create teacher
  /// BackPropagationLearning teacher = new BackPropagationLearning( network );
  /// // loop
  /// while ( !needToStop )
  /// {
  ///     // run epoch of learning procedure
  ///     double error = teacher.RunEpoch( input, output );
  ///     // check error value to see if we need to stop
  ///     // ...
  /// }
  /// </code>
  /// </remarks>
  ///
  /// <seealso cref="EvolutionaryLearning"/>
  ///
  TBackPropagationLearning = class(TInterfacedObject,ISupervisedLearning)
  //private
    FNetwork          : TAttivazNetwork;  // network to teach
    /// <summary>
    /// Learning rate, [0, 1].
    /// </summary>
    ///
    /// <remarks><para>The value determines speed of learning.</para>
    ///
    /// <para>Default value equals to <b>0.1</b>.</para>
    /// </remarks>
    ///
    FFattAppr         : Double;           // [0,1] Determina la velocità di apprendimento di default è 0.1.
    /// <summary>
    /// Momentum, [0, 1].
    /// </summary>
    ///
    /// <remarks><para>The value determines the portion of previous weight's update
    /// to use on current iteration. Weight's update values are calculated on
    /// each iteration depending on neuron's error. The momentum specifies the amount
    /// of update to use from previous iteration and the amount of update
    /// to use from current iteration. If the value is equal to 0.1, for example,
    /// then 0.1 portion of previous update and 0.9 portion of current update are used
    /// to update weight's value.</para>
    ///
    /// <para>Default value equals to <b>0.0</b>.</para>
    ///	</remarks>
    ///
    FOnPassEpoche     : TOnEpochPassed;
		FMomento          : Double;           // [0,1] momentum di default è 0.0
    FNeuronErrori     : AADouble  ;       // array di appoggio x errori neuroni
		FPesiModifi       : array of AADouble;// array di appoggio x pesi da modificare
    FthresholdsModifi : AADouble;         // array di appoggio x x threshold da modificare
    function  CalcolaErrore(OutputDesiderato : array of Double):Double; virtual;
    procedure AggiornaPesi( Input : array of Double);
    procedure AggiornaRete;
  public
    constructor Create(Net : TAttivazNetwork);
    function Run( Input, Output: ADouble ):Double;
    function RunEpoch( Input, Output:AADouble):Double;

    property FattApprendimento : Double           read FFattAppr write FFattAppr;
    property Momento           : Double           read FMomento write FMomento;
    property TheNet            : TAttivazNetwork  read FNetwork; // network to teach
    property NeuronErrori      : AADouble         read FNeuronErrori;
    property OnPassEpoche      : TOnEpochPassed   read FOnPassEpoche write FOnPassEpoche;
  end;

  /// <summary>
  /// Delta rule learning algorithm.
  /// </summary>
  ///
  /// <remarks><para>This learning algorithm is used to train one layer neural
  /// network of <see cref="ActivationNeuron">Activation Neurons</see>
  /// with continuous activation function, see <see cref="SigmoidFunction"/>
  /// for example.</para>
  ///
  /// <para>See information about <a href="http://en.wikipedia.org/wiki/Delta_rule">delta rule</a>
  /// learning algorithm.</para>
  /// </remarks>
  ///
  TDeltaRuleLearning = class(TInterfacedObject,ISupervisedLearning)
  private
    FNetwork  : TAttivazNetwork;  // Rete da Addestrare
    FFattAppr : Double;           // [0,1] Determina la velocità di apprendimento di default è 0.1.
  public
    constructor Create(Net : TAttivazNetwork);
    function Run( Input, Output: ADouble ):Double;virtual;
    function RunEpoch( Input, Output:AADouble):Double;

    property FattApprendimento : Double read FFattAppr write FFattAppr;
  end;

  /// <summary>
  /// Elastic network learning algorithm.
  /// </summary>
  ///
  /// <remarks><para>This class implements elastic network's learning algorithm and
  /// allows to train <see cref="DistanceNetwork">Distance Networks</see>.</para>
  /// </remarks>
  ///
  TElasticLearning  = class(TInterfacedObject,IUnsupervisedLearning)
  private
    FNetwork    : TDistanzaNetwork;  // Rete da Addestrare
    FFattAppr   : Double;            // [0,1] Determina la velocità di apprendimento di default è 0.1.
    FDistanza   : ADouble;           // Distanza tra neuroni
    FRaggioAppr : Double;            // Raggio di apprendimento
    FQuadRaggio : Double;            // Quadrato del raggio di apprendimento
    procedure SetRaggio(const Value: Double);
  public
    constructor Create(Net : TDistanzaNetwork);
    function Run( Input : ADouble ):Double;
    function RunEpoch( Input : AADouble):Double;

    property FattApprendimento : Double read FFattAppr write FFattAppr;
    property RaggioAppr : Double read FRaggioAppr write SetRaggio;
  end;

  /// <summary>
  /// Perceptron learning algorithm.
  /// </summary>
  ///
  /// <remarks><para>This learning algorithm is used to train one layer neural
  /// network of <see cref="ActivationNeuron">Activation Neurons</see>
  /// with the <see cref="ThresholdFunction">Threshold</see>
  /// activation function.</para>
  ///
  /// <para>See information about <a href="http://en.wikipedia.org/wiki/Perceptron">Perceptron</a>
  /// and its learning algorithm.</para>
  /// </remarks>
  ///
  TPerceptronLearning = class(TInterfacedObject,ISupervisedLearning)
  private
    FNetwork  : TAttivazNetwork;  // Rete da Addestrare
    FFattAppr : Double;           // [0,1] Determina la velocità di apprendimento di default è 0.1.
  public
    constructor Create(Net : TAttivazNetwork);
    function Run( Input, Output: ADouble ):Double;
    function RunEpoch( Input, Output:AADouble):Double;

    property FattApprendimento : Double read FFattAppr write FFattAppr;
  end;

  /// <summary>
  /// Kohonen Self Organizing Map (SOM) learning algorithm.
  /// </summary>
  ///
  /// <remarks><para>This class implements Kohonen's SOM learning algorithm and
  /// is widely used in clusterization tasks. The class allows to train
  /// <see cref="DistanceNetwork">Distance Networks</see>.</para>
  ///
  /// <para>Sample usage (clustering RGB colors):</para>
  /// <code>
  /// // set range for randomization neurons' weights
  /// Neuron.RandRange = new Range( 0, 255 );
  /// // create network
  /// DistanceNetwork	network = new DistanceNetwork(
  ///         3, // thress inputs in the network
  ///         100 * 100 ); // 10000 neurons
  /// // create learning algorithm
  /// SOMLearning	trainer = new SOMLearning( network );
  /// // network's input
  /// double[] input = new double[3];
  /// // loop
  /// while ( !needToStop )
  /// {
  ///     input[0] = rand.Next( 256 );
  ///     input[1] = rand.Next( 256 );
  ///     input[2] = rand.Next( 256 );
  ///
  ///     trainer.Run( input );
  ///
  ///     // ...
  ///     // update learning rate and radius continuously,
  ///     // so networks may come steady state
  /// }
  /// </code>
  /// </remarks>
  ///
  TSOMLearning = class(TInterfacedObject,IUnsupervisedLearning)
  private
    FNetwork    : TDistanzaNetwork;  // Rete da Addestrare
    FFattAppr   : Double;            // [0,1] Determina la velocità di apprendimento di default è 0.1.
    FWidth      : Integer;           // Dimensione rete
    FHeight     : Integer;           //
    FRaggioAppr : Double;            // Raggio di apprendimento
    FQuadRaggio : Double;            // Quadrato del raggio di apprendimento
    procedure SetRaggio(const Value: Double);
  public
    constructor Create(Net : TDistanzaNetwork);overload;
    constructor Create(Net : TDistanzaNetwork;Width, Height: Integer);overload;
    function Run( Input : ADouble ):Double;
    function RunEpoch( Input : AADouble):Double;

    property FattApprendimento : Double read FFattAppr write FFattAppr;
    property RaggioAppr : Double read FRaggioAppr write SetRaggio;
  end;

  /// <summary>
  /// Resilient Backpropagation learning algorithm.
  /// </summary>
  ///
  /// <remarks><para>This class implements the resilient backpropagation (RProp)
  /// learning algorithm. The RProp learning algorithm is one of the fastest learning
  /// algorithms for feed-forward learning networks which use only first-order
  /// information.</para>
  ///
  /// <para>Sample usage (training network to calculate XOR function):</para>
  /// <code>
  /// // initialize input and output values
  /// double[][] input = new double[4][] {
  ///     new double[] {0, 0}, new double[] {0, 1},
  ///     new double[] {1, 0}, new double[] {1, 1}
  /// };
  /// double[][] output = new double[4][] {
  ///     new double[] {0}, new double[] {1},
  ///     new double[] {1}, new double[] {0}
  /// };
  /// // create neural network
  /// ActivationNetwork   network = new ActivationNetwork(
  ///     SigmoidFunction( 2 ),
  ///     2, // two inputs in the network
  ///     2, // two neurons in the first layer
  ///     1 ); // one neuron in the second layer
  /// // create teacher
  /// ResilientBackpropagationLearning teacher = new ResilientBackpropagationLearning( network );
  /// // loop
  /// while ( !needToStop )
  /// {
  ///     // run epoch of learning procedure
  ///     double error = teacher.RunEpoch( input, output );
  ///     // check error value to see if we need to stop
  ///     // ...
  /// }
  /// </code>
  /// </remarks>
  ///
  TResilientBackpropagationLearning = class(TInterfacedObject,ISupervisedLearning)
  private
    FNetwork           : TAttivazNetwork;  // network to teach
    FFattAppr          : Double;           // [0,1] Determina la velocità di apprendimento di default è 0.1.
    FDeltaMax          : Double;
    FDeltaMin          : Double;
    FEtaMinus          : Double;
    FEtaPlus           : Double;

    FNeuronErrori      : AADouble  ;       // array di appoggio x errori neuroni
		FPesiModifi        : array of AADouble;// array di appoggio x pesi da modificare
		FthresholdsModifi  : AADouble;         // array di appoggio x x threshold da modificare
    FDerivatePesi      : array of AADouble;
    FThresholdsDeriv   : AADouble;
    FPreDerivatePesi   : array of AADouble;
    FPreThresholdsDeriv: AADouble;
    procedure ResetGradient;
    procedure ResetUpdates( rate : Double  );
    procedure AggiornaRete;
    function  CalcolaErrore(OutputDesiderato : ADouble):Double;
    procedure CalculateGradient( input : ADouble );
    procedure SetFattAppr(const Value: Double);

  public
    constructor Create(Net : TAttivazNetwork);
    function Run( Input, Output: ADouble ):Double;
    function RunEpoch( Input, Output:AADouble):Double;
    property FattApprendimento : Double read FFattAppr write SetFattAppr;
  end;

implementation

{ TBackPropagationLearning }

/// <summary>
/// Initializes a new instance of the <see cref="BackPropagationLearning"/> class.
/// </summary>
///
/// <param name="network">Network to teach.</param>
///
constructor TBackPropagationLearning.Create(Net: TAttivazNetwork);
(***************************************************************************)
var
 i,j : Integer;
begin
     FNetwork := Net;
     FMomento := 0.0;
     FFattAppr:= 0.1;
     SetLength(FNeuronErrori,     FNetwork.LayersCount);
     SetLength(FPesiModifi,       FNetwork.LayersCount);
     SetLength(FthresholdsModifi, FNetwork.LayersCount);

     // inizilizza arrays per tutti i layer
     for i := 0 to FNetwork.LayersCount - 1 do
     begin
          SetLength(FNeuronErrori[i],    FNetwork.Layer[i].NeuronCount);
				  SetLength(FPesiModifi[i],      FNetwork.Layer[i].NeuronCount);
				  SetLength(FthresholdsModifi[i],FNetwork.Layer[i].NeuronCount);

          // per tutti i neuroni del layer
          for j := 0 to Length(FPesiModifi[i]) - 1  do
               SetLength(FPesiModifi[i][j], FNetwork.Layer[i].InputCount);
     end;

end;

/// <summary>
/// Runs learning iteration.
/// </summary>
///
/// <param name="input">Input vector.</param>
/// <param name="output">Desired output vector.</param>
///
/// <returns>Returns squared error (difference between current network's output and
/// desired output) divided by 2.</returns>
///
/// <remarks><para>Runs one learning iteration and updates neuron's
/// weights.</para></remarks>
///
function TBackPropagationLearning.Run(Input, Output: ADouble): Double;
(***************************************************************************)
begin
     // Calcola l'output delle rete
     FNetwork.Compute(Input);
     // calcola l'errore della rete
     Result := CalcolaErrore(Output);
     // calcola le modifiche dei pesi
     AggiornaPesi(Input);
     // aggiorna la rete
     AggiornaRete;
end;

/// <summary>
/// Runs learning epoch.
/// </summary>
///
/// <param name="input">Array of input vectors.</param>
/// <param name="output">Array of output vectors.</param>
///
/// <returns>Returns summary learning error for the epoch. See <see cref="Run"/>
/// method for details about learning error calculation.</returns>
///
/// <remarks><para>The method runs one learning epoch, by calling <see cref="Run"/> method
/// for each vector provided in the <paramref name="input"/> array.</para></remarks>
///
function TBackPropagationLearning.RunEpoch(Input, Output: AADouble): Double;
(***************************************************************************)
var
 Errore : Double;
 i      : Integer;
begin
     Errore := 0.0;

			// Avvia la procedura di addestramento per tutti gli esempi
      for i := 0 to  Length(Input) -1 do
      begin
			 	  Errore := Errore + Run( input[i], output[i] );
          if Assigned(FOnPassEpoche) then
             FOnPassEpoche(i);
      end;
      // Ritorna le'errore
			Result :=  Errore;
end;

/// <summary>
/// Calculates error values for all neurons of the network.
/// </summary>
///
/// <param name="desiredOutput">Desired output vector.</param>
///
/// <returns>Returns summary squared error of the last layer divided by 2.</returns>
///
function TBackPropagationLearning.CalcolaErrore(OutputDesiderato: array of Double):Double;
(****************************************************************************************)
var
 Errore, e, Somma,
 Output             : Double;            // valori per gli errori
 LayerCount,i,k,j   : Integer;           // numero di layer
 Funz               : IActivationFunction;
begin
     Errore     := 0.0;
     layerCount := FNetwork.LayersCount;
     // Si assume che tutti i neuroni di tutta la rete hanno la stessa funzione
	   Funz   := FNetwork.Layer[0].Neurone[0].FunzAttiv;

		 // Calcola l'errore dell'ultimo layer per primo
		 for i := 0 to FNetwork.Layer[layerCount - 1].NeuronCount- 1 do
     begin
          try
              output :=FNetwork.Layer[layerCount - 1].Neurone[i].Output;
              // errore del neurone
              e      := OutputDesiderato[i] - output;
              // errore moltiplicato per la derivata della funzione di attivazione
              FNeuronErrori[layerCount - 1][i] := e * Funz.Derivata2( output );
              // Quadrato dell'errore + l'errore
              errore := errore + ( e * e );
          except
              on Exception do Exception.Create('[BP] Errore nella procedura CalcolaErrore '   );
          end;
     end;

			// Calcola il valore dell'errore negli altri layer
			for  j := layerCount - 2 downto 0 do
			begin
           // per tutti i neuroni del layer
           for i := 0 to FNetwork.Layer[j].NeuronCount -1 do
				   begin
					      Somma := 0.0;
					      // per tutti i neuroni del prossimo layer
                for k := 0 to FNetwork.Layer[j + 1].NeuronCount -1 do
				        begin
					           Somma := Somma + (FNeuronErrori[j + 1][k] * FNetwork.Layer[j + 1].Neurone[k].Pesi[i]);
					      end;
					      FNeuronErrori[j][i] := Somma * Funz.Derivata2( FNetwork.Layer[j].Neurone[i].Output );
				   end;
			end;
      Result := Errore / 2;
end;

/// <summary>
/// Calculate weights updates.
/// </summary>
///
/// <param name="input">Network's input vector.</param>
///
procedure TBackPropagationLearning.AggiornaPesi(Input: array of Double);
(***************************************************************************)
var
  CachedMomentum     : Double;      // cache per valori usati di frequente
  Cached1mMomentum   : Double;      // cache per valori usati di frequente
  CachedErrore       : Double;      // cache per valori usati di frequente
  i,j,k              : Integer;
begin

      // cache i valori di uso frequente
      CachedMomentum   := FFattAppr * Momento;
      Cached1mMomentum := FFattAppr * (1 - Momento);

      // 1 - calcola le modifiche per il primo layer prima
			// Per tutti i neuroni del layer
      for i := 0 to FNetwork.Layer[0].NeuronCount - 1 do
			begin
           cachedErrore     := FNeuronErrori[0][i] * cached1mMomentum;
           // per tutti i pesi del Neurone
           for j := 0 to  Length(FPesiModifi[0][i])  -1 do
			   	 begin
					      // calcola la modifica del peso
                FPesiModifi[0][i][j] := cachedMomentum * FPesiModifi[0][i][j] + cachedErrore * input[j];
				   end;

			   	 // calcola la modifica di treshold
				   FthresholdsModifi[0][i] := cachedMomentum * FthresholdsModifi[0][i] + cachedErrore;
			end;

			// 2 - per tutti gli altri layer
      for k := 1 to FNetwork.LayersCount - 1 do
			begin
				   // per tutti i neuroni del layer
           for i := 0 to FNetwork.Layer[k].NeuronCount - 1 do
				   begin
                cachedErrore	  := FNeuronErrori[k][i] * cached1mMomentum;
                // per tutte le connessioni del neurone
                for j := 0 to Length(FPesiModifi[k][i]) - 1 do
					      begin
						         // calcola la modifica del peso
                     FPesiModifi[k][i][j] := cachedMomentum * FPesiModifi[k][i][j] + cachedErrore * FNetwork.Layer[k - 1].Neurone[j].Output;
					      end;

					      // calcola la modifica di treshold
					      FthresholdsModifi[k][i] := cachedMomentum * FthresholdsModifi[k][i] + cachedErrore;
				   end;
			end;
end;

/// <summary>
/// Update network'sweights.
/// </summary>
///
procedure TBackPropagationLearning.AggiornaRete;
(***************************************************************************)
var
  i,j,k              : Integer;
begin
		 // Per tutti i layer della rete
     for i := 0 to FNetwork.LayersCount - 1 do
		 begin
		      //Per tutti i neuroni del layer
          for j := 0 to FNetwork.Layer[i].NeuronCount -1 do
				  begin
					     // per tutti i pesi del neurone
               for k := 0 to FNetwork.Layer[i].Neurone[j].InputCount - 1 do
					     begin
						        // modifica peso
                    FNetwork.Layer[i].Neurone[j].Pesi[k] := FNetwork.Layer[i].Neurone[j].Pesi[k] + FPesiModifi[i][j][k];
						   end;
					     // modifica treshold
					     FNetwork.Layer[i].Neurone[j].Threshold := FNetwork.Layer[i].Neurone[j].Threshold + FthresholdsModifi[i][j];
          end;

     end;
end;

{ TDeltaRuleLearning }

/// <summary>
/// Initializes a new instance of the <see cref="DeltaRuleLearning"/> class.
/// </summary>
///
/// <param name="network">Network to teach.</param>
///
/// <exception cref="ArgumentException">Invalid nuaral network. It should have one layer only.</exception>
///
constructor TDeltaRuleLearning.Create(Net: TAttivazNetwork);
(***************************************************************************)
begin
     FFattAppr := 0.1;
     if Net.LayersCount > 1 then
        raise Exception.Create('Rete Neurale non Valida. Questo tipo può avere solo un Layer.');

     FNetwork := Net;
end;

/// <summary>
/// Runs learning iteration.
/// </summary>
///
/// <param name="input">Input vector.</param>
/// <param name="output">Desired output vector.</param>
///
/// <returns>Returns squared error (difference between current network's output and
/// desired output) divided by 2.</returns>
///
/// <remarks><para>Runs one learning iteration and updates neuron's
/// weights.</para></remarks>
///
function TDeltaRuleLearning.Run(Input, Output: ADouble): Double;
(***************************************************************************)
var
 NetOutput : ADouble;
 Funz      : IActivationFunction; // funzione di attivazzione
 Errore, e : Double;              // valori per gli errori
 FunzDeriv : Double;              // risultato della derivata della funzione
 i,j       : Integer;

begin
     // Calcola l'output delle rete
     NetOutput := FNetwork.Compute(Input);
     // Preleva Funzione di Attivazione
     Funz      := TAttivazLayer(FNetwork.Layer[0]).Neurone[0].FunzAttiv;

     Errore := 0.0;
     // Modifica pesi per ogni neurone
		 for j := 0 to FNetwork.Layer[0].NeuronCount -1 do
		 begin
           // Calcola l'errore del neurone
           e := Output[j] - NetOutput[j];
           // calcolo derivata
           FunzDeriv := Funz.Derivata2( NetOutput[j] );
           // Modifica dei pesi
           for i := 0 to FNetwork.Layer[0].Neurone[j].InputCount - 1 do
					 begin
					      FNetwork.Layer[0].Neurone[j].Pesi[i] := FNetwork.Layer[0].Neurone[j].Pesi[i] +
                                                             (FFattAppr * e * FunzDeriv * Input[i]);
					 end;
					 // modifica treshold
					 FNetwork.Layer[0].Neurone[j].Threshold := FNetwork.Layer[0].Neurone[j].Threshold +
                                                             (FFattAppr * e * FunzDeriv);

           Errore := Errore +( e * e);
     end;
     Result := Errore / 2;
end;

/// <summary>
/// Runs learning epoch.
/// </summary>
///
/// <param name="input">Array of input vectors.</param>
/// <param name="output">Array of output vectors.</param>
///
/// <returns>Returns summary learning error for the epoch. See <see cref="Run"/>
/// method for details about learning error calculation.</returns>
///
/// <remarks><para>The method runs one learning epoch, by calling <see cref="Run"/> method
/// for each vector provided in the <paramref name="input"/> array.</para></remarks>
///
function TDeltaRuleLearning.RunEpoch(Input, Output: AADouble): Double;
(***************************************************************************)
var
 Errore : Double;
 i      : Integer;
begin
     Errore := 0.0;

			// Avvia la procedura di addestramento per tutti gli esempi
      for i := 0 to  Length(Input) -1 do
      begin
			 	   Errore := Errore + Run( input[i], output[i] );
           //DoOnEpochPassed
      end;
      // Ritorna le'errore
			Result :=  Errore;
end;

{ TElasticLearning }

/// <summary>
/// Initializes a new instance of the <see cref="ElasticNetworkLearning"/> class.
/// </summary>
///
/// <param name="network">Neural network to train.</param>
///
constructor TElasticLearning.Create(Net: TDistanzaNetwork);
(***************************************************************************)
var
 NeuronCount,i    : Integer;
 Alpha,DeltaAlpha : Double;
 dx,dy            : Double;
begin
    FFattAppr   := 0.1;
    FRaggioAppr := 0.5;
    FQuadRaggio := 2 * 7 * 7;
    FNetwork    := Net;

    NeuronCount := FNetwork.Layer[0].NeuronCount;
    DeltaAlpha  := (Pi * 2 ) / NeuronCount;
    Alpha       := DeltaAlpha;

    SetLength(FDistanza,NeuronCount);
    FDistanza[0] := 0.0;
    // Calcolo di tutti i valori delle distanze
    for i := 0 to NeuronCount - 1 do
    begin
         dx           := 0.5 * Cos( Alpha ) - 0.5;
         dy           := 0.5 * Sin( Alpha );
         FDistanza[i] := dx * dx + dy * dy;
         Alpha        := Alpha + DeltaAlpha;
    end;
end;

/// <summary>
/// Runs learning iteration.
/// </summary>
///
/// <param name="input">Input vector.</param>
///
/// <returns>Returns learning error - summary absolute difference between neurons'
/// weights and appropriate inputs. The difference is measured according to the neurons
/// distance to the winner neuron.</returns>
///
/// <remarks><para>The method runs one learning iterations - finds winner neuron (the neuron
/// which has weights with values closest to the specified input vector) and updates its weight
/// (as well as weights of neighbor neurons) in the way to decrease difference with the specified
/// input vector.</para></remarks>
///
function TElasticLearning.Run(Input: ADouble):Double;
(***************************************************************************)
var
 Errore,e : Double;
 Fattore  : Double;
 Winner   : Integer;
 j,i      : Integer;

begin
    Errore := 0.0;
    // Calcolo della rete
    FNetwork.Compute(Input) ;
    Winner := FNetwork.GetWinner;

    // per tutti i neuroni del layer
    for j := 0 to FNetwork.Layer[0].NeuronCount - 1 do
    begin
         //Aggiorna Fattore
         Fattore := Exp( - FDistanza[Abs( j - winner )] / FQuadRaggio );
         // Aggiorna tutti i pesi del neurone
         for i := 0 to FNetwork.Layer[0].Neurone[j].InputCount - 1 do
         begin
              // Calcola l'errore
              e := (Input[i] -  FNetwork.Layer[0].Neurone[j].Pesi[i]) * Fattore;
              Errore := Errore + Abs(e);
              // Aggiorna i pesi
              FNetwork.Layer[0].Neurone[j].Pesi[i] :=  FNetwork.Layer[0].Neurone[j].Pesi[i] + (e * FFattAppr);
         end;
    end;
    Result := Errore;

end;

/// <summary>
/// Runs learning epoch.
/// </summary>
///
/// <param name="input">Array of input vectors.</param>
///
/// <returns>Returns summary learning error for the epoch. See <see cref="Run"/>
/// method for details about learning error calculation.</returns>
///
/// <remarks><para>The method runs one learning epoch, by calling <see cref="Run"/> method
/// for each vector provided in the <paramref name="input"/> array.</para></remarks>
///
function TElasticLearning.RunEpoch(Input: AADouble):Double;
(***************************************************************************)
var
 Errore : Double;
 i      : Integer;
begin
     Errore := 0.0;
     for i := 0 to Length(Input) - 1 do
     begin
          Errore := Errore + Run(Input[i]);
          //DoOnEpochPassed
     end;
     Result := Errore;

end;

procedure TElasticLearning.SetRaggio(const Value: Double);
(***************************************************************************)
begin
  FRaggioAppr := Value;
  FQuadRaggio := 2 * FRaggioAppr * FRaggioAppr;
end;

{ TPerceptronLearning }

/// <summary>
/// Initializes a new instance of the <see cref="PerceptronLearning"/> class.
/// </summary>
///
/// <param name="network">Network to teach.</param>
///
/// <exception cref="ArgumentException">Invalid nuaral network. It should have one layer only.</exception>
///
constructor TPerceptronLearning.Create(Net: TAttivazNetwork);
(***************************************************************************)
begin
     FFattAppr := 0.1;
     if Net.LayersCount > 1 then
        raise Exception.Create('Rete Neurale non Valida. Questo tipo può avere solo un .');

     FNetwork := Net;
end;

/// <summary>
/// Runs learning iteration.
/// </summary>
///
/// <param name="input">Input vector.</param>
/// <param name="output">Desired output vector.</param>
///
/// <returns>Returns absolute error - difference between current network's output and
/// desired output.</returns>
///
/// <remarks><para>Runs one learning iteration and updates neuron's
/// weights in the case if neuron's output is not equal to the
/// desired output.</para></remarks>
///
function TPerceptronLearning.Run(Input, Output: ADouble): Double;
(***************************************************************************)
var
 NetOutput        : ADouble;
 Errore           : Double;
 e                : Double;
 Percetrone       :^TDistanzeNeuron;// neurone
 Layer            :^TAttivazLayer ; // layer
 j,k,i,n          : Integer;
begin
     // Calcola Output della rete
     NetOutput := FNetwork.Compute( Input );

     // preleva l'unico layer della rete
     Layer  := Pointer(FNetwork.Layer[0]);

     Errore := 0.0;

     // per tutti i neuroni del layer
     k := TLayer(Layer).NeuronCount;
     for j := 0  to k -1 do
     begin
          e := Output[j] - NetOutput[j];
          if  e <> 0  then
          begin
               Percetrone := Pointer(TLayer(Layer).Neurone[j]);

               // modifica i pesi
               n := TNeuron(Percetrone).InputCount;
               for i := 0 to n -1 do
                   TNeuron(Percetrone).Pesi[i] := TNeuron(Percetrone).Pesi[i]+
                                              (FFattAppr * e * Input[i]);
               // Modifica il valore di threshold
               TAttivazNeuron(Percetrone).threshold := TAttivazNeuron(Percetrone).threshold+
                                              (FFattAppr * e);
               // calcola il valore assoluto dell'errore
               Errore := Errore + Abs( e );
          end;
     end;
     Result := Errore;

end;

/// <summary>
/// Runs learning epoch.
/// </summary>
///
/// <param name="input">Array of input vectors.</param>
/// <param name="output">Array of output vectors.</param>
///
/// <returns>Returns summary learning error for the epoch. See <see cref="Run"/>
/// method for details about learning error calculation.</returns>
///
/// <remarks><para>The method runs one learning epoch, by calling <see cref="Run"/> method
/// for each vector provided in the <paramref name="input"/> array.</para></remarks>
///
function TPerceptronLearning.RunEpoch(Input, Output: AADouble): Double;
(***************************************************************************)
var
 Errore : Double;
 i,n    : Integer;
begin
     Errore := 0.0;

			// Avvia la procedura di addestramento per tutti gli esempi
      n := Length(Input);
			for i := 0 to  n -1 do
      begin
			 	   Errore := Errore + Run( input[i], output[i] );
           //DoOnEpochPassed
      end;
      // Ritorna le'errore
			Result :=  Errore;
end;

{ TSOMLearning }

/// <summary>
/// Initializes a new instance of the <see cref="SOMLearning"/> class.
/// </summary>
///
/// <param name="network">Neural network to train.</param>
///
/// <remarks><para>This constructor supposes that a square network will be passed for training -
/// it should be possible to get square root of network's neurons amount.</para></remarks>
///
/// <exception cref="ArgumentException">Invalid network size - square network is expected.</exception>
///
constructor TSOMLearning.Create(Net: TDistanzaNetwork);
(***************************************************************************)
var
 NeuronCount : Integer;
 width       : Integer;
begin

     NeuronCount := Net.Layer[0].NeuronCount;
     width       := Trunc(Sqrt(NeuronCount));

     if (width * width) <> NeuronCount then
        raise Exception.Create('DImensioni Rete Errate');

     FFattAppr   := 0.1;
     FRaggioAppr := 7;
     FQuadRaggio := 2 * 7 * 7;

     FNetwork := Net;
     FWidth   := width;
     FHeight  := width;
end;

/// <summary>
/// Initializes a new instance of the <see cref="SOMLearning"/> class.
/// </summary>
///
/// <param name="network">Neural network to train.</param>
/// <param name="width">Neural network's width.</param>
/// <param name="height">Neural network's height.</param>
///
/// <remarks>The constructor allows to pass network of arbitrary rectangular shape.
/// The amount of neurons in the network should be equal to <b>width</b> * <b>height</b>.
/// </remarks>
///
/// <exception cref="ArgumentException">Invalid network size - network size does not correspond
/// to specified width and height.</exception>
///
constructor TSOMLearning.Create(Net: TDistanzaNetwork; Width, Height: Integer);
(***************************************************************************)
begin
     if (Net.Layer[0].NeuronCount) <> (Width * Height) then
         raise Exception.Create('DImensioni Rete Errate');

     FFattAppr   := 0.1;
     FRaggioAppr := 7;
     FQuadRaggio := 2 * 7 * 7;

     FNetwork := Net;
     FWidth   := width;
     FHeight  := Height;

end;

/// <summary>
/// Runs learning iteration.
/// </summary>
///
/// <param name="input">Input vector.</param>
///
/// <returns>Returns learning error - summary absolute difference between neurons' weights
/// and appropriate inputs. The difference is measured according to the neurons
/// distance to the winner neuron.</returns>
///
/// <remarks><para>The method runs one learning iterations - finds winner neuron (the neuron
/// which has weights with values closest to the specified input vector) and updates its weight
/// (as well as weights of neighbor neurons) in the way to decrease difference with the specified
/// input vector.</para></remarks>
///
function TSOMLearning.Run(Input: ADouble): Double;
(***************************************************************************)
var
 Errore,e     : Double;
 Fattore      : Double;
 Winner,wx,wy : Integer;
 j,i,dx,dy: Integer;

begin
    Errore := 0.0;
    FNetwork.Compute(Input) ;
    Winner := FNetwork.GetWinner;

    // Controllo raggio di Apprendimento
    if FRaggioAppr = 0 then
    begin
         // Aggiorna i pesi solo per il neurone vincitore
         for i := 0 to  FNetwork.Layer[0].Neurone[Winner].InputCount - 1 do
         begin
              // Calcola l'errore
              e := Input[i] - FNetwork.Layer[0].Neurone[Winner].Pesi[i] ;
              // calcola il valore assoluto dell'errore
              Errore := Errore + Abs( e );
              // Aggiorna i pesi
              FNetwork.Layer[0].Neurone[Winner].Pesi[i] := FNetwork.Layer[0].Neurone[Winner].Pesi[i] + ( e* FFattAppr);
         end;
    end
    else begin
         // vincitori X e Y
         wx := Winner mod FWidth;
         wy := Winner div FWidth ;
         // per tutti i neuroni del layer
         for j := 0 to FNetwork.Layer[0].NeuronCount -1 do
         begin
              dx  := (j mod FWidth) - wx;
              dy  := Trunc(j / FWidth) - wy;

              // aggiorna fattore( Base Gaussiana)
              Fattore := Exp(-(dx * dx + dy * dy)  / FQuadRaggio);
              // aggiorna pesi neurone
              for i := 0 to FNetwork.Layer[0].Neurone[j].InputCount - 1 do
              begin
                   // Calcola l'errore
                   e := (Input[i] - FNetwork.Layer[0].Neurone[j].Pesi[i]) * Fattore ;
                   // calcola il valore assoluto dell'errore
                   Errore := Errore + Abs( e );
                   // Aggiorna i pesi
                   FNetwork.Layer[0].Neurone[j].Pesi[i] := FNetwork.Layer[0].Neurone[j].Pesi[i] + ( e* FFattAppr);
              end;
         end;
    end;
    Result := Errore;
end;

/// <summary>
/// Runs learning epoch.
/// </summary>
///
/// <param name="input">Array of input vectors.</param>
///
/// <returns>Returns summary learning error for the epoch. See <see cref="Run"/>
/// method for details about learning error calculation.</returns>
///
/// <remarks><para>The method runs one learning epoch, by calling <see cref="Run"/> method
/// for each vector provided in the <paramref name="input"/> array.</para></remarks>
///
function TSOMLearning.RunEpoch(Input: AADouble): Double;
(***************************************************************************)
var
 Errore : Double;
 i      : Integer;
begin
     Errore := 0.0;
     for i := 0 to Length(Input) - 1 do
     begin
          Errore := Errore + Run(Input[i]);
          //DoOnEpochPassed
     end;
     Result := Errore;
end;

procedure TSOMLearning.SetRaggio(const Value: Double);
(***************************************************************************)
begin
     FRaggioAppr := Max(0,Value);
     FQuadRaggio := 2 * FRaggioAppr * FRaggioAppr;
end;

{ TResilientBackpropagationLearning }

/// <summary>
/// Initializes a new instance of the <see cref="ResilientBackpropagationLearning"/> class.
/// </summary>
///
/// <param name="network">Network to teach.</param>
///
constructor TResilientBackpropagationLearning.Create(Net: TAttivazNetwork);
var
  nLayerCount    : Integer;
  i,j,NeuroCount : Integer;
begin
     FFattAppr := 0.0125;
     FDeltaMax := 50.0;
     FDeltaMin := 1e-6;
     FEtaMinus := 0.5;
     FEtaPlus  := 1.2;

     FNetwork   := Net;
     nLayerCount:= FNetwork.LayersCount;

     SetLength(FNeuronErrori,nLayerCount);

     SetLength(FDerivatePesi,nLayerCount);
     SetLength(FThresholdsDeriv,nLayerCount);

     SetLength(FPreDerivatePesi,nLayerCount);
     SetLength(FPreThresholdsDeriv,nLayerCount);

     SetLength(FPesiModifi,nLayerCount);
     SetLength(FthresholdsModifi,nLayerCount);

      // Inizializzazione errori, derivativate e passi
      for i := 0 to FNetwork.LayersCount -1 do
      begin
          NeuroCount := FNetwork.Layer[i].NeuronCount ;

          SetLength(FNeuronErrori[i],NeuroCount);

          SetLength(FDerivatePesi[i]   ,NeuroCount);
          SetLength(FPreDerivatePesi[i],NeuroCount);
          SetLength(FPesiModifi[i]     ,NeuroCount);

          SetLength(FThresholdsDeriv[i]   ,NeuroCount);
          SetLength(FPreThresholdsDeriv[i],NeuroCount);
          SetLength(FthresholdsModifi[i]  ,NeuroCount);

          // per ogni neurone
          for  j := 0 to FNetwork.Layer[i].NeuronCount do
          begin
              SetLength(FDerivatePesi[i][j]   ,FNetwork.Layer[i].Neurone[j].InputCount);
              SetLength(FPreDerivatePesi[i][j],FNetwork.Layer[i].Neurone[j].InputCount);
              SetLength(FPesiModifi[i][j]     ,FNetwork.Layer[i].Neurone[j].InputCount);
          end;
      end;
      // intialize steps
      ResetUpdates( FFattAppr );
end;

/// <summary>
/// Learning rate.
/// </summary>
///
/// <remarks><para>The value determines speed of learning.</para>
///
/// <para>Default value equals to <b>0.0125</b>.</para>
/// </remarks>
///
procedure TResilientBackpropagationLearning.SetFattAppr(const Value: Double);
begin
  FFattAppr := Value;
  ResetUpdates( FFattAppr ) ;
end;

/// <summary>
/// Runs learning iteration.
/// </summary>
///
/// <param name="input">Input vector.</param>
/// <param name="output">Desired output vector.</param>
///
/// <returns>Returns squared error (difference between current network's output and
/// desired output) divided by 2.</returns>
///
/// <remarks><para>Runs one learning iteration and updates neuron's
/// weights.</para></remarks>
///
function TResilientBackpropagationLearning.Run(Input, Output: ADouble): Double;
var
  Errore : Double;
begin
     // zero gradiente
     ResetGradient;
     // Calcola l'output delle rete
     FNetwork.Compute(Input);
     // calcola l'errore della rete
     Errore := CalcolaErrore(Output);
     // calcola le modifiche dei pesi
     CalculateGradient(input);
     // aggiorna la rete
     AggiornaRete;

     Result := Errore;
end;

/// <summary>
/// Runs learning epoch.
/// </summary>
///
/// <param name="input">Array of input vectors.</param>
/// <param name="output">Array of output vectors.</param>
///
/// <returns>Returns summary learning error for the epoch. See <see cref="Run"/>
/// method for details about learning error calculation.</returns>
///
/// <remarks><para>The method runs one learning epoch, by calling <see cref="Run"/> method
/// for each vector provided in the <paramref name="input"/> array.</para></remarks>
///
function TResilientBackpropagationLearning.RunEpoch(Input, Output: AADouble): Double;
var
 Errore : Double;
 i      : Integer;
begin
     Errore := 0.0;

			// Avvia la procedura di addestramento per tutti gli esempi
      for i := 0 to  Length(Input) -1 do
      begin
           // Calcola l'output delle rete
           FNetwork.Compute(Input[i]);
           // calcola l'errore della rete
           Errore := Errore + CalcolaErrore(Output[i]);

           // calcola le modifiche dei pesi
           CalculateGradient(input[i]);
			 	   //DoOnEpochPassed
      end;
      // aggiorna la rete
      AggiornaRete;
      // Ritorna le'errore
			Result :=  Errore;
end;

/// <summary>
/// Resets current weight and threshold derivatives.
/// </summary>
///
procedure TResilientBackpropagationLearning.ResetGradient;
var
  i,j : Integer;
begin
     for i := 0 to Length(FDerivatePesi) - 1 do
     begin
          for j := 0 to  Length(FDerivatePesi[i]) do
          begin
               ZeroMemory(@FDerivatePesi[i][j], Length(FDerivatePesi[i][j]));
              //Array.Clear( FDerivatePesi[i][j], 0, FDerivatePesi[i][j].Length );
          end;
     end;

     for i := 0 to  Length(FThresholdsDeriv) do
     begin
          ZeroMemory(@FThresholdsDeriv[i], Length(FThresholdsDeriv[i]));
          //Array.Clear( FThresholdsDeriv[i], 0, FThresholdsDeriv[i].Length );
     end;
end;

/// <summary>
/// Resets the current update steps using the given learning rate.
/// </summary>
///
procedure TResilientBackpropagationLearning.ResetUpdates(rate: Double);
var
  i,j,k : Integer;
begin
     for i := 0 to  Length(FPesiModifi) -1 do
         for j := 0 to Length(FPesiModifi[i]) do
           for k := 0 to Length(FPesiModifi[i][j]) do
               FPesiModifi[i][j][k] := rate;

     for i := 0 to Length(FthresholdsModifi) do
          for  j := 0 to  Length(FthresholdsModifi[i]) do
               FthresholdsModifi[i][j] := rate;
end;

/// <summary>
/// Update network's weights.
/// </summary>
///
procedure TResilientBackpropagationLearning.AggiornaRete;
var
  i,j,k : Integer;
  S     : Double;
begin
      // per ogni layer della rete
      for i := 0 to  FNetwork.LayersCount -1 do
      begin
           // per ogni neurone del layer
           for j := 0 to FNetwork.Layer[i].NeuronCount do
           begin
                // per ogni peso del neurone
                for k := 0 to FNetwork.Layer[i].Neurone[j].InputCount do
                begin
                     S := FPreDerivatePesi[i][j][k] *  FDerivatePesi[i][j][k];
                     if ( S > 0 ) then
                     begin
                            FPesiModifi[i][j][k] := Min( FPesiModifi[i][j][k] * FEtaPlus, FDeltaMax );
                            FNetwork.Layer[i].Neurone[j].Pesi[k] := FNetwork.Layer[i].Neurone[j].Pesi[k] -
                                                            Sign( FDerivatePesi[i][j][k] ) * FPesiModifi[i][j][k];
                            FPreDerivatePesi[i][j][k] := FDerivatePesi[i][j][k];
                     end
                     else if ( S < 0 )  then
                     begin
                            FPesiModifi[i][j][k] := Max( FPesiModifi[i][j][k] * FEtaMinus, FDeltaMin );
                            FPreDerivatePesi[i][j][k] := 0;
                     end else
                     begin
                            FNetwork.Layer[i].Neurone[j].Pesi[k] := FNetwork.Layer[i].Neurone[j].Pesi[k] -
                                                            Sign( FDerivatePesi[i][j][k] ) * FPesiModifi[i][j][k];
                            FPreDerivatePesi[i][j][k] := FDerivatePesi[i][j][k];
                     end
                end;
                // Modifica treshold
                S := FPreThresholdsDeriv[i][j] * FThresholdsDeriv[i][j];
                if ( S > 0 ) then
                begin
                    FthresholdsModifi[i][j] := Min( FthresholdsModifi[i][j] * FEtaPlus, FDeltaMax );
                    FNetwork.Layer[i].Neurone[j].Threshold := FNetwork.Layer[i].Neurone[j].Threshold -
                                                     Sign(  FThresholdsDeriv[i][j] ) * FthresholdsModifi[i][j];
                    FPreThresholdsDeriv[i][j] := FThresholdsDeriv[i][j];
                end
                else if ( S < 0 )  then
                begin
                    FthresholdsModifi[i][j] := Max( FthresholdsModifi[i][j] * FEtaMinus, FDeltaMin );
                    FThresholdsDeriv[i][j]  := 0;
                end else
                begin
                    FNetwork.Layer[i].Neurone[j].Threshold := FNetwork.Layer[i].Neurone[j].Threshold -
                                                     Sign( FThresholdsDeriv[i][j] ) * FthresholdsModifi[i][j];
                    FPreThresholdsDeriv[i][j] := FThresholdsDeriv[i][j];
                end;
           end;
      end;
end;

/// <summary>
/// Calculates error values for all neurons of the network.
/// </summary>
///
/// <param name="desiredOutput">Desired output vector.</param>
///
/// <returns>Returns summary squared error of the last layer divided by 2.</returns>
///
function TResilientBackpropagationLearning.CalcolaErrore(OutputDesiderato: ADouble): Double;
var
 Errore, e, Somma,
 Output             : Double;            // valori per gli errori
 LayerCount,i,k,j   : Integer;           // numero di layer
 Funz               : IActivationFunction;
begin
     Errore     := 0.0;
     layerCount := FNetwork.LayersCount;
     // Si assume che tutti i neuroni di tutta la rete hanno la stessa funzione
	   Funz   := FNetwork.Layer[0].Neurone[0].FunzAttiv;

		 // Calcola l'errore dell'ultimo layer per primo
		 for i := 0 to FNetwork.Layer[layerCount - 1].NeuronCount- 1 do
     begin
          try
              output :=FNetwork.Layer[layerCount - 1].Neurone[i].Output;
              // errore del neurone
              e      := output - OutputDesiderato[i];
              // errore moltiplicato per la derivata della funzione di attivazione
              FNeuronErrori[layerCount - 1][i] := e * Funz.Derivata2( output );
              // Quadrato dell'errore + l'errore
              errore := errore + ( e * e );
          except
              on Exception do Exception.Create('[RBP] Errore nella procedura CalcolaErrore '   );
          end;
     end;

     // Calcola il valore dell'errore negli altri layer
     for  j := layerCount - 2 downto 0 do
     begin
         // per tutti i neuroni del layer
         for i := 0 to FNetwork.Layer[j].NeuronCount -1 do
         begin
              Somma := 0.0;
              // per tutti i neuroni del prossimo layer
              for k := 0 to FNetwork.Layer[j + 1].NeuronCount -1 do
              begin
                   Somma := Somma + (FNeuronErrori[j + 1][k] * FNetwork.Layer[j + 1].Neurone[k].Pesi[i]);
              end;
              FNeuronErrori[j][i] := Somma * Funz.Derivata2( FNetwork.Layer[j].Neurone[i].Output );
         end;
     end;
     Result := Errore / 2;
end;

/// <summary>
/// Calculate weights updates
/// </summary>
///
/// <param name="input">Network's input vector.</param>
///
procedure TResilientBackpropagationLearning.CalculateGradient(input: ADouble);
var
  i,j,k : Integer;
begin
      // 1 - calcola le modifiche per il primo layer prima
      // Per tutti i neuroni del layer
      for i := 0 to FNetwork.Layer[0].NeuronCount - 1 do
			begin
           // per tutti i pesi del Neurone
           for j := 0 to  FNetwork.Layer[0].Neurone[i].InputCount  -1 do
			   	 begin
					      // calcola la modifica del peso
                FDerivatePesi[0][i][j] :=  FNeuronErrori[0][i] * input[j];
				   end;
           // calcola la modifica di treshold
				   FThresholdsDeriv[0][i] :=  FThresholdsDeriv[0][i] + FNeuronErrori[0][i] ;
			end;

			// 2 - per tutti gli altri layer
      for k := 1 to FNetwork.LayersCount - 1 do
			begin
				   // per tutti i neuroni del layer
           for i := 0 to FNetwork.Layer[k].NeuronCount - 1 do
				   begin
                // per tutte le connessioni del neurone
                for j := 0 to FNetwork.Layer[k - 1].NeuronCount - 1 do
					      begin
						         // calcola la modifica del peso
                     FDerivatePesi[k][i][j] := FDerivatePesi[k][i][j] + FNeuronErrori[k][i] * FNetwork.Layer[k - 1].Neurone[j].Output;
					      end;
                // calcola la modifica di treshold
					      FThresholdsDeriv[k][i] := FThresholdsDeriv[k][i] + FNeuronErrori[k][i];
				   end;
			end;
end;

end.
