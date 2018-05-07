// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
//
// 
//
unit Layer;

interface
uses
  Windows, Messages, SysUtils, Classes,Neuron,NeuralNetDef,FunzAttivazione;

type
  /// <summary>
  /// Base neural layer class.
  /// </summary>
  ///
  /// <remarks>This is a base neural layer class, which represents
  /// collection of neurons.</remarks>
  ///
  TLayer = class(TObject)
  protected
    /// <summary>
    /// Layer's inputs count.
    /// </summary>
    FInputCount : Integer;

    /// <summary>
    /// Layer's neurons count.
    /// </summary>
    FNeuronCount: Integer;

    /// <summary>
    /// Layer's neurons.
    /// </summary>
    FNeuroni    : array of TNeuron;

    /// <summary>
    /// Layer's output vector.
    /// </summary>
    FOutput     : ADouble;
    function    GetNeurone(Index: Integer): TNeuron;
  public
    constructor Create(NeuronCount, InputCount: Integer);
    destructor Destroy; override;
    procedure  GenRandom(min : Double = 0.0; max : Double = 1.0);
    function   Compute(AInput: array of Double): ADouble;
    /// <summary>
    /// Layer's inputs count.
    /// </summary>
    property InputCount : Integer read FInputCount;
    /// <summary>
    /// Layer's neurons count.
    /// </summary>
    ///
    property NeuronCount: Integer read FNeuronCount;
    /// <summary>
    /// Layer's output vector.
    /// </summary>
    ///
    /// <remarks><para>The calculation way of layer's output vector is determined by neurons,
    /// which comprise the layer.</para>
    ///
    /// <para><note>The property is not initialized (equals to <see langword="null"/>) until
    /// <see cref="Compute"/> method is called.</note></para>
    /// </remarks>
    ///
    property Output :     ADouble read FOutput;
    property Neurone[Index: Integer] : TNeuron read GetNeurone;
  end;

  /// <summary>
  /// Distance layer.
  /// </summary>
  ///
  /// <remarks>Distance layer is a layer of <see cref="DistanceNeuron">distance neurons</see>.
  /// The layer is usually a single layer of such networks as Kohonen Self
  /// Organizing Map, Elastic Net, Hamming Memory Net.</remarks>
  ///
  TDistanzeLayer = class(TLayer)
  private
    function GetNeurone(Index: Integer): TDistanzeNeuron;
  public
    constructor Create(NeuronCount, InputCount: Integer);

    property Neurone[Index: Integer] : TDistanzeNeuron read GetNeurone;
  end;

  /// <summary>
  /// Activation layer.
  /// </summary>
  ///
  /// <remarks>Activation layer is a layer of <see cref="ActivationNeuron">activation neurons</see>.
  /// The layer is usually used in multi-layer neural networks.</remarks>
  ///
  TAttivazLayer = class(TLayer)
  private
    function GetNeurone(Index: Integer): TAttivazNeuron;
  public
    constructor Create(NeuronCount, InputCount: Integer;Funz: IActivationFunction);
    procedure SetFunzAttivaz(FunzAtt: IActivationFunction);

    property Neurone[Index: Integer] : TAttivazNeuron read GetNeurone;
  end;


implementation

{ TLayer }

/// <summary>
/// Initializes a new instance of the <see cref="Layer"/> class.
/// </summary>
///
/// <param name="neuronsCount">Layer's neurons count.</param>
/// <param name="inputsCount">Layer's inputs count.</param>
///
/// <remarks>Protected contructor, which initializes <see cref="inputsCount"/>,
/// <see cref="neuronsCount"/> and <see cref="neurons"/> members.</remarks>
///
constructor TLayer.Create(NeuronCount, InputCount: Integer);
(**************************************************************)
begin
    SetLength(FNeuroni,NeuronCount);
    FInputCount := InputCount;
    FNeuronCount:= NeuronCount;

end;

destructor TLayer.Destroy;
(**************************************************************)
 var
  i : Integer;
begin
    for i := 0 to FNeuronCount -1 do  FNeuroni[i].Free;
    SetLength(FNeuroni,0);
    inherited;
end;

/// <summary>
/// Compute output vector of the layer.
/// </summary>
///
/// <param name="input">Input vector.</param>
///
/// <returns>Returns layer's output vector.</returns>
///
/// <remarks><para>The actual layer's output vector is determined by neurons,
/// which comprise the layer - consists of output values of layer's neurons.
/// The output vector is also stored in <see cref="Output"/> property.</para>
///
/// <para><note>The method may be called safely from multiple threads to compute layer's
/// output value for the specified input values. However, the value of
/// <see cref="Output"/> property in multi-threaded environment is not predictable,
/// since it may hold layer's output computed from any of the caller threads. Multi-threaded
/// access to the method is useful in those cases when it is required to improve performance
/// by utilizing several threads and the computation is based on the immediate return value
/// of the method, but not on layer's output property.</note></para>
/// </remarks>
///
function TLayer.Compute(AInput: array of Double): ADouble;
(**************************************************************)
var
 i     : Integer;
 Output: ADouble;
begin
     SetLength(Output,FNeuronCount);

     SetLength(FOutput,FNeuronCount);
     for i := 0 to FNeuronCount - 1 do
        FOutput[i] := FNeuroni[i].ComputeOut(AInput);
     Result := FOutput;
end;

procedure TLayer.GenRandom(min : Double = 0.0; max : Double = 1.0);
(**************************************************************)
var
  i : Integer;
begin
     for i := 0 to FNeuronCount - 1 do
      FNeuroni[i].GenRandom(min,max);
end;

function TLayer.GetNeurone(Index: Integer): TNeuron;
(**************************************************************)
begin
     Result := FNeuroni[index]
end;

{ TDistanzeLayer }

/// <summary>
/// Initializes a new instance of the <see cref="DistanceLayer"/> class.
/// </summary>
///
/// <param name="neuronsCount">Layer's neurons count.</param>
/// <param name="inputsCount">Layer's inputs count.</param>
///
/// <remarks>The new layet is randomized (see <see cref="Neuron.Randomize"/>
/// method) after it is created.</remarks>
///
constructor TDistanzeLayer.Create(NeuronCount, InputCount: Integer);
(**************************************************************)
var
 i : Integer;
begin
     inherited Create(NeuronCount, InputCount);

     for i := 0 to NeuronCount - 1 do
        FNeuroni[i] := TDistanzeNeuron.Create(InputCount);

end;

function TDistanzeLayer.GetNeurone(Index: Integer): TDistanzeNeuron;
(**************************************************************)
begin
     Result := inherited GetNeurone(Index) as TDistanzeNeuron
end;

{ TAttivazLayer }

/// <summary>
/// Initializes a new instance of the <see cref="ActivationLayer"/> class.
/// </summary>
///
/// <param name="neuronsCount">Layer's neurons count.</param>
/// <param name="inputsCount">Layer's inputs count.</param>
/// <param name="function">Activation function of neurons of the layer.</param>
///
/// <remarks>The new layer is randomized (see <see cref="ActivationNeuron.Randomize"/>
/// method) after it is created.</remarks>
///
constructor TAttivazLayer.Create(NeuronCount, InputCount: Integer;Funz: IActivationFunction);
(**************************************************************)
var
 i : Integer;
begin
     inherited Create(NeuronCount, InputCount);

     for i := 0 to NeuronCount - 1 do
        FNeuroni[i] := TAttivazNeuron.Create(InputCount,Funz) ;

end;

function TAttivazLayer.GetNeurone(Index: Integer): TAttivazNeuron;
(**************************************************************)
begin
     Result := inherited GetNeurone(Index) as TAttivazNeuron
end;

procedure TAttivazLayer.SetFunzAttivaz(FunzAtt: IActivationFunction);
(**************************************************************)
var
 i : Integer;
begin
     for i := 0 to NeuronCount - 1 do
        (FNeuroni[i] as TAttivazNeuron).FunzAttiv := FunzAtt;
end;

end.
