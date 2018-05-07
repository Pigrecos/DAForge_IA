// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit Network;

interface
uses
  Windows, Messages, SysUtils, Classes,System.Math,Neuron,FunzAttivazione,NeuralNetDef,Layer;

type

  /// <summary>
  /// Base neural network class.
  /// </summary>
  ///
  /// <remarks>This is a base neural netwok class, which represents
  /// collection of neuron's layers.</remarks>
  ///
  TNetwork = class(TObject)
  private
    function GetLayer(Index: Integer): TLayer;
  protected
    /// <summary>
    /// Network's inputs count.
    /// </summary>
    FInputsCount : Integer;

    /// <summary>
    /// Network's layers count.
    /// </summary>
    FLayersCount : Integer ;

    /// <summary>
    /// Network's layers.
    /// </summary>
    FLayers      : array of TLayer;

    /// <summary>
    /// Network's output vector.
    /// </summary>
    FOutput      : ADouble;
  public
    constructor Create( InputsCount, LayersCount: Integer);
    destructor Destroy; override;
    procedure  GenRandom(min : Double = 0.0; max : Double = 1.0);
    function   Compute(AInput : array of Double): ADouble; virtual;
    /// <summary>
    /// Network's inputs count.
    /// </summary>
    property   InputCount  : Integer read FInputsCount;
    // <summary>
    /// Network's layers count.
    /// </summary>
    property   LayersCount : Integer read FLayersCount;
    /// <summary>
    /// Network's output vector.
    /// </summary>
    ///
    /// <remarks><para>The calculation way of network's output vector is determined by
    /// layers, which comprise the network.</para>
    ///
    /// <para><note>The property is not initialized (equals to <see langword="null"/>) until
    /// <see cref="Compute"/> method is called.</note></para>
    /// </remarks>
    ///
    property   Output      : ADouble read FOutput;
    property   Layer[Index: Integer] : TLayer read GetLayer;
  end;

  /// <summary>
  /// Distance network.
  /// </summary>
  ///
  /// <remarks>Distance network is a neural network of only one <see cref="DistanceLayer">distance
  /// layer</see>. The network is a base for such neural networks as SOM, Elastic net, etc.
  /// </remarks>
  ///
  TDistanzaNetwork = class(TNetwork)
  private
    function GetLayer(Index: Integer): TDistanzeLayer;
  public
    constructor Create(InputsCount, NeuronCount: Integer);
    function GetWinner:Integer;

    property Layer[Index: Integer] : TDistanzeLayer read GetLayer;
  end;

  /// <summary>
  /// Activation network.
  /// </summary>
  ///
  /// <remarks><para>Activation network is a base for multi-layer neural network
  /// with activation functions. It consists of <see cref="ActivationLayer">activation
  /// layers</see>.</para>
  ///
  /// <para>Sample usage:</para>
  /// <code>
  /// // create activation network
  ///	ActivationNetwork network = new ActivationNetwork(
  ///		new SigmoidFunction( ), // sigmoid activation function
  ///		3,                      // 3 inputs
  ///		4, 1 );                 // 2 layers:
  ///                             // 4 neurons in the firs layer
  ///                             // 1 neuron in the second layer
  ///	</code>
  /// </remarks>
  ///
  TAttivazNetwork = class(TNetwork)
  private
    function GetLayer(Index: Integer): TAttivazLayer;
  public
    constructor Create(const Funz: IActivationFunction;InputsCount: Integer; NeuronsXLayer : array of Integer);
    procedure SetActivationFunction(Funz: IActivationFunction);

    property Layer[Index: Integer] : TAttivazLayer read GetLayer;
  end;


implementation

{ TNetwork }

/// <summary>
/// Initializes a new instance of the <see cref="Network"/> class.
/// </summary>
///
/// <param name="inputsCount">Network's inputs count.</param>
/// <param name="layersCount">Network's layers count.</param>
///
/// <remarks>Protected constructor, which initializes <see cref="inputsCount"/>,
/// <see cref="layersCount"/> and <see cref="layers"/> members.</remarks>
///
constructor TNetwork.Create(InputsCount, LayersCount: Integer);
(***************************************************************)
begin
     FInputsCount := max(1,InputsCount);
     FLayersCount := max(1,LayersCount);
     // crea lista di layer
     SetLength(FLayers,FLayersCount);

end;

destructor TNetwork.Destroy;
(***************************************************************)
var
  i : Integer;
begin
     for i := 0 to FLayersCount - 1 do FLayers[i].Free;
     SetLength(FLayers,0);
     inherited;
end;

/// <summary>
/// Compute output vector of the network.
/// </summary>
///
/// <param name="input">Input vector.</param>
///
/// <returns>Returns network's output vector.</returns>
///
/// <remarks><para>The actual network's output vecor is determined by layers,
/// which comprise the layer - represents an output vector of the last layer
/// of the network. The output vector is also stored in <see cref="Output"/> property.</para>
///
/// <para><note>The method may be called safely from multiple threads to compute network's
/// output value for the specified input values. However, the value of
/// <see cref="Output"/> property in multi-threaded environment is not predictable,
/// since it may hold network's output computed from any of the caller threads. Multi-threaded
/// access to the method is useful in those cases when it is required to improve performance
/// by utilizing several threads and the computation is based on the immediate return value
/// of the method, but not on network's output property.</note></para>
/// </remarks>
///
function TNetwork.Compute(AInput: array of Double): ADouble;
(***************************************************************)
var
 i      : Integer;
 Output : aDouble ;
begin

     SetLength(Output,Length(AInput));
     for i := 0 to Length(AInput) - 1 do Output[i] := AInput[i];

     for i := 0 to FLayersCount - 1 do  Output := FLayers[i].Compute(Output);

     FOutput := Output;
     Result  := Output
end;

procedure TNetwork.GenRandom(min : Double = 0.0; max : Double = 1.0);
(***************************************************************)
var
 i      : Integer;
begin
     for i := 0 to FLayersCount - 1 do
      FLayers[i].GenRandom(min,max);
end;

function TNetwork.GetLayer(Index: Integer): TLayer;
(***************************************************************)
begin
     Result := FLayers[index]
end;

{ TDistanzaNetwork }

/// <summary>
/// Initializes a new instance of the <see cref="DistanceNetwork"/> class.
/// </summary>
///
/// <param name="inputsCount">Network's inputs count.</param>
/// <param name="neuronsCount">Network's neurons count.</param>
///
/// <remarks>The new network is randomized (see <see cref="Neuron.Randomize"/>
/// method) after it is created.</remarks>
///
constructor TDistanzaNetwork.Create(InputsCount, NeuronCount: Integer);
(***************************************************************)
begin
  inherited Create(InputCount,1);
  FLayers[0] := TDistanzeLayer.Create(NeuronCount,InputsCount);

end;

function TDistanzaNetwork.GetLayer(Index: Integer): TDistanzeLayer;
(***************************************************************)
begin
      Result := FLayers[index] as TDistanzeLayer;
end;

/// <summary>
/// Get winner neuron.
/// </summary>
///
/// <returns>Index of the winner neuron.</returns>
///
/// <remarks>The method returns index of the neuron, which weights have
/// the minimum distance from network's input.</remarks>
///
function TDistanzaNetwork.GetWinner: Integer;
(***************************************************************)
var
 Output       : ADouble;
 min          : Double;
 minIndex,i   : Integer;
begin
    Output   := FOutput;
    min      := Output[0] ;
    minIndex := 0;

    for i := 1 to Length(Output)  - 1 do
    begin
         if Output[i] < min then
         begin
              // Trovato nuovo valore minimo
              min      := Output[i];
              minIndex := i;
         end;
    end;
    Result := minIndex;
end;

{ TAttivazNetwork }

/// <summary>
/// Initializes a new instance of the <see cref="ActivationNetwork"/> class.
/// </summary>
///
/// <param name="function">Activation function of neurons of the network.</param>
/// <param name="inputsCount">Network's inputs count.</param>
/// <param name="neuronsCount">Array, which specifies the amount of neurons in
/// each layer of the neural network.</param>
///
/// <remarks>The new network is randomized (see <see cref="ActivationNeuron.Randomize"/>
/// method) after it is created.</remarks>
///
constructor TAttivazNetwork.Create(const Funz: IActivationFunction; InputsCount: Integer; NeuronsXLayer: array of Integer);
(***********************************************************************************************************************)
var
 i : Integer;
begin
     inherited Create(InputsCount, Length(NeuronsXLayer));
     for i := 0 to FLayersCount - 1 do
     begin
          if i = 0 then  FLayers[i] :=  TAttivazLayer.Create(NeuronsXLayer[i],InputsCount,Funz)
          else           FLayers[i] :=  TAttivazLayer.Create(NeuronsXLayer[i],NeuronsXLayer[i-1],Funz)
     end;
end;

function TAttivazNetwork.GetLayer(Index: Integer): TAttivazLayer;
(***************************************************************)
begin
      Result := FLayers[index] as TAttivazLayer;
end;

/// <summary>
/// Set new activation function for all neurons of the network.
/// </summary>
///
/// <param name="function">Activation function to set.</param>
///
/// <remarks><para>The method sets new activation function for all neurons by calling
/// <see cref="ActivationLayer.SetActivationFunction"/> method for each layer of the network.</para></remarks>
///
procedure TAttivazNetwork.SetActivationFunction(Funz: IActivationFunction);
(***************************************************************)
var
 i : Integer;
begin
     for i := 0 to FLayersCount - 1 do
        (FLayers[i] as TAttivazLayer).SetFunzAttivaz( Funz );

end;

end.
