// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit Neuron;

interface
uses
  Windows, Messages, SysUtils, Classes,System.Math,FunzAttivazione;

type
  TRangeRnd = record
     Min : Double;
     Max : Double;
  end;

  /// <summary>
  /// Base neuron class.
  /// </summary>
  ///
  /// <remarks>This is a base neuron class, which encapsulates such
  /// common properties, like neuron's input, output and weights.</remarks>
  ///
  TNeuron = class(TObject)
  private
    function  GetRange: TRangeRnd;
    procedure SetRange(const Value: TRangeRnd);
  protected
    /// <summary>
    /// Neuron's output value.
    /// </summary>
    FOutput         : double;

    /// <summary>
    /// Nouron's wieghts.
    /// </summary>
    FPesi           : array of Double;

    /// <summary>
    /// Neuron's inputs count.
    /// </summary>
    FInputCount     : Integer;

    /// <summary>
    /// Random generator range.
    /// </summary>
    ///
    /// <remarks>Sets the range of random generator. Affects initial values of neuron's weight.
    /// Default value is [0, 1].</remarks>
    ///
    FRandomRange    : TRangeRnd;
    function  GetPesi(Index: integer): double;
    procedure SetPesi(Index: integer; Value: double);
  public
    constructor Create(numInput: Integer);
    destructor  Destroy; override;
    procedure   GenRandom(min : Double = 0.0; max : Double = 1.0); virtual;
    function    ComputeOut(const AInputs: array of Double):Double; virtual;abstract;
    /// <summary>
    /// Neuron's output value.
    /// </summary>
    ///
    /// <remarks>The calculation way of neuron's output value is determined by inherited class.</remarks>
    ///
    property Output              : double       read FOutput ;
    /// <summary>
    /// Neuron's inputs count.
    /// </summary>
    property InputCount          : integer      read FInputCount;
    property Pesi[Index: integer]: double       read GetPesi       write SetPesi;
    property RandomRange         : TRangeRnd    read GetRange      write SetRange;
  end;

  /// <summary>
  /// Distance neuron.
  /// </summary>
  ///
  /// <remarks><para>Distance neuron computes its output as distance between
  /// its weights and inputs - sum of absolute differences between weights'
  /// values and corresponding inputs' values. The neuron is usually used in Kohonen
  /// Self Organizing Map.</para></remarks>
  ///
  TDistanzeNeuron = class(TNeuron)
  public
    constructor Create(numInput : Integer);
    function    ComputeOut(const AInputs: array of Double):Double;override;
  end;

  /// <summary>
  /// Activation neuron.
  /// </summary>
  ///
  /// <remarks><para>Activation neuron computes weighted sum of its inputs, adds
  /// threshold value and then applies <see cref="ActivationFunction">activation function</see>.
  /// The neuron isusually used in multi-layer neural networks.</para></remarks>
  ///
  /// <seealso cref="IActivationFunction"/>
  ///
  TAttivazNeuron = class(TNeuron)
  protected
    /// <summary>
    /// Threshold value.
    /// </summary>
    ///
    /// <remarks>The value is added to inputs weighted sum before it is passed to activation
    /// function.</remarks>
    ///
    Fthreshold : Double;

    /// <summary>
    /// Activation function.
    /// </summary>
    ///
    /// <remarks>The function is applied to inputs weighted sum plus
    /// threshold value.</remarks>
    ///
    FFunzAttiv : IActivationFunction;
  public
    constructor Create(numInput: Integer;AttFunz: IActivationFunction);
    function    ComputeOut(const AInputs: array of Double):Double;override;
    procedure  GenRandom(min : Double = 0.0; max : Double = 1.0);override;
    /// <summary>
    /// Neuron's activation function.
    /// </summary>
    ///
    property FunzAttiv : IActivationFunction read FFunzAttiv write FFunzAttiv;
    /// <summary>
    /// Threshold value.
    /// </summary>
    ///
    /// <remarks>The value is added to inputs weighted sum before it is passed to activation
    /// function.</remarks>
    ///
    property threshold : Double           read Fthreshold write Fthreshold;
  end;


implementation

{ TNeuron }

/// <summary>
/// Initializes a new instance of the <see cref="Neuron"/> class.
/// </summary>
///
/// <param name="inputs">Neuron's inputs count.</param>
///
/// <remarks>The new neuron will be randomized (see <see cref="Randomize"/> method)
/// after it is created.</remarks>
///
constructor TNeuron.Create(numInput: Integer);
(************************************************)
begin
     FOutput := 0;
     FInputCount := Max(1,numInput);
     SetLength(FPesi,FInputCount);
     FRandomRange.Min := 0.0;
     FRandomRange.Max := 1.0;

     GenRandom;
end;

destructor TNeuron.Destroy;
(************************************************)
begin
     SetLength(FPesi,0);
     inherited;
end;

procedure TNeuron.GenRandom(min : Double = 0.0; max : Double = 1.0);
(************************************************)
var
  i : Integer;
begin
     RandSeed := GetTickCount;
     Randomize;

     FRandomRange.Min := min;
     FRandomRange.Max := max;
     for i := 0 to Length(FPesi) - 1 do
        FPesi[i] := Random * 2.0 - 1.0;//* FRandomRange.Max + FRandomRange.Min;

end;

function TNeuron.GetPesi(Index: integer): double;
(************************************************)
begin
  try
    Result := FPesi[Index];
  except
    on E: ERangeError do
      raise E.CreateFmt('Indice non compreso nell''Intervallo', [Index])
  end;
end;

procedure TNeuron.SetPesi(Index: integer; Value: double);
(********************************************************)
begin
  try
    FPesi[Index] := Value;
  except
    on E: ERangeError do
      raise E.CreateFmt('Indice non compreso nell''Intervallo', [Index])
  end;
end;

procedure TNeuron.SetRange(const Value:TRangeRnd);
(********************************************************)
begin
    FRandomRange.Min := Value.Min;
    FRandomRange.Max := Value.Max;

end;

function TNeuron.GetRange: TRangeRnd;
(********************************************************)
begin
     Result.Min := FRandomRange.Min;
     Result.Max := FRandomRange.Max;
end;

{ TDistanzeNeuron }

/// <summary>
/// Initializes a new instance of the <see cref="DistanceNeuron"/> class.
/// </summary>
///
/// <param name="inputs">Neuron's inputs count.</param>
///
constructor TDistanzeNeuron.Create(numInput: Integer);
(*****************************************************)
begin
   inherited Create(numInput);
end;

/// <summary>
/// Computes output value of neuron.
/// </summary>
///
/// <param name="input">Input vector.</param>
///
/// <returns>Returns neuron's output value.</returns>
///
/// <remarks><para>The output value of distance neuron is equal to the distance
/// between its weights and inputs - sum of absolute differences.
/// The output value is also stored in <see cref="Neuron.Output">Output</see>
/// property.</para>
///
/// <para><note>The method may be called safely from multiple threads to compute neuron's
/// output value for the specified input values. However, the value of
/// <see cref="Neuron.Output"/> property in multi-threaded environment is not predictable,
/// since it may hold neuron's output computed from any of the caller threads. Multi-threaded
/// access to the method is useful in those cases when it is required to improve performance
/// by utilizing several threads and the computation is based on the immediate return value
/// of the method, but not on neuron's output property.</note></para>
/// </remarks>
///
/// <exception cref="ArgumentException">Wrong length of the input vector, which is not
/// equal to the <see cref="Neuron.InputsCount">expected value</see>.</exception>
///
function TDistanzeNeuron.ComputeOut(const AInputs: array of Double): Double;
(****************************************************************************)
var
 i   : Integer;
 Diff: Double;
begin
    // valore differenza
    Diff   := 0.0 ;
    if Length(AInputs) <> FInputCount then  raise Exception.Create('Lunghezza del vettore di input Errato.');

    // calcola distanza tra input e peso
    for i := 0 to FInputCount - 1 do
        Diff := Diff + Abs( FPesi[i] - AInputs[i] );

    FOutput := Diff;
    Result  := FOutput;
end;

{ TAttivazNeuron }

/// <summary>
/// Initializes a new instance of the <see cref="ActivationNeuron"/> class.
/// </summary>
///
/// <param name="inputs">Neuron's inputs count.</param>
/// <param name="function">Neuron's activation function.</param>
///
constructor TAttivazNeuron.Create(numInput: Integer;AttFunz: IActivationFunction);
(******************************************************************************)
begin
     inherited Create(numInput);
     FFunzAttiv := AttFunz;

     Fthreshold := Random * 2.0 - 1.0;//* FRandomRange.Max + FRandomRange.Min;
end;

/// <summary>
/// Computes output value of neuron.
/// </summary>
///
/// <param name="input">Input vector.</param>
///
/// <returns>Returns neuron's output value.</returns>
///
/// <remarks><para>The output value of activation neuron is equal to value
/// of nueron's activation function, which parameter is weighted sum
/// of its inputs plus threshold value. The output value is also stored
/// in <see cref="Neuron.Output">Output</see> property.</para>
///
/// <para><note>The method may be called safely from multiple threads to compute neuron's
/// output value for the specified input values. However, the value of
/// <see cref="Neuron.Output"/> property in multi-threaded environment is not predictable,
/// since it may hold neuron's output computed from any of the caller threads. Multi-threaded
/// access to the method is useful in those cases when it is required to improve performance
/// by utilizing several threads and the computation is based on the immediate return value
/// of the method, but not on neuron's output property.</note></para>
/// </remarks>
///
/// <exception cref="ArgumentException">Wrong length of the input vector, which is not
/// equal to the <see cref="Neuron.InputsCount">expected value</see>.</exception>
///
function TAttivazNeuron.ComputeOut(const AInputs: array of Double): Double;
(**************************************************************************)
var
 i    : Integer;
 Somma: Double;
begin
    // valore somma iniziale
    Somma  := 0.0 ;
    if Length(AInputs) <> FInputCount then  raise Exception.Create('Lunghezza del vettore di input Errato.');

    try
    // calcola la somma dei pesi per l'input
    for i := 0 to Length(FPesi) - 1 do
        Somma := Somma + (FPesi[i] * AInputs[i] );
    Somma := Somma + Fthreshold;
    Except
       raise Exception.Create('Somma: '+floattostr(Somma));
    end;

    FOutput := FFunzAttiv.Funzione(Somma);
    Result  := FOutput;
end;

procedure TAttivazNeuron.GenRandom(min : Double = 0.0; max : Double = 1.0);
(***************************************************************************)
var
  i : Integer;
begin
     RandSeed := GetTickCount;
     Randomize;
     FRandomRange.Min := min;
     FRandomRange.Max := max;
     for i := 0 to Length(FPesi) - 1 do
        FPesi[i] := Random * 2.0 - 1.0;//* FRandomRange.Max + FRandomRange.Min;

     Fthreshold :=Random * 2.0 - 1.0;//* FRandomRange.Max + FRandomRange.Min;

end;

end.
