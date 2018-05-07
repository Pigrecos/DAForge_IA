// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit Cromosomi;

interface
uses
  Windows, Messages, SysUtils, Classes,System.Math,
  MathUtil,NeuralNetDef;

type
  IChromosome = interface;

  /// <summary>
  /// Fitness function interface.
  /// </summary>
  ///
  /// <remarks>The interface should be implemented by all fitness function
  /// classes, which are supposed to be used for calculation of chromosomes
  /// fitness values. All fitness functions should return positive (<b>greater
  /// then zero</b>) value, which indicates how good is the evaluated chromosome -
  /// the greater the value, the better the chromosome.
  /// </remarks>
  IFitnessFunction = interface
    ['{1DFDF956-3CB5-47FF-97AA-2A056647CE4A}']

      /// <summary>
      /// Evaluates chromosome.
      /// </summary>
      ///
      /// <param name="chromosome">Chromosome to evaluate.</param>
      ///
      /// <returns>Returns chromosome's fitness value.</returns>
      ///
      /// <remarks>The method calculates fitness value of the specified
      /// chromosome.</remarks>
      ///
      function Evaluate(chromosome : IChromosome ): Double;
  end;

  /// <summary>
  /// Chromosome interface.
  /// </summary>
  ///
  /// <remarks><para>The interfase should be implemented by all classes, which implement
  /// particular chromosome type.</para></remarks>
  ///
  IChromosome = interface
    ['{7FC47A72-8F0F-4220-8235-F2FEF2F6DEF7}']

    /// <summary>
    /// Chromosome's fintess value.
    /// </summary>
    ///
    /// <remarks><para>The fitness value represents chromosome's usefulness - the greater the
    /// value, the more useful it.</para></remarks>
    ///
    function Fitness :Double;

    /// <summary>
    /// Generate random chromosome value.
    /// </summary>
    ///
    /// <remarks><para>Regenerates chromosome's value using random number generator.</para>
    /// </remarks>
    ///
    procedure Generate;

    /// <summary>
    /// Create new random chromosome with same parameters (factory method).
    /// </summary>
    ///
    /// <remarks><para>The method creates new chromosome of the same type, but randomly
    /// initialized. The method is useful as factory method for those classes, which work
    /// with chromosome's interface, but not with particular chromosome class.</para></remarks>
    ///
    function CreateNew: IChromosome;

    /// <summary>
    /// Clone the chromosome.
    /// </summary>
    ///
    /// <remarks><para>The method clones the chromosome returning the exact copy of it.</para>
    /// </remarks>
    ///
    function Clone: IChromosome;

    /// <summary>
    /// Mutation operator.
    /// </summary>
    ///
    /// <remarks><para>The method performs chromosome's mutation, changing its part randomly.</para></remarks>
    ///
    procedure Mutate;

    /// <summary>
    /// Crossover operator.
    /// </summary>
    ///
    /// <param name="pair">Pair chromosome to crossover with.</param>
    ///
    /// <remarks><para>The method performs crossover between two chromosomes – interchanging some parts of chromosomes.</para></remarks>
    ///
    procedure Crossover(var pair: IChromosome );

    /// <summary>
    /// Evaluate chromosome with specified fitness function.
    /// </summary>
    ///
    /// <param name="function">Fitness function to use for evaluation of the chromosome.</param>
    ///
    /// <remarks><para>Calculates chromosome's fitness using the specifed fitness function.</para></remarks>
    ///
    procedure Evaluate(fun: IFitnessFunction );

    function ToString: string;
  end;

  /// <summary>
  /// Chromosomes' base class.
  /// </summary>
  ///
  /// <remarks><para>The base class provides implementation of some <see cref="IChromosome"/>
  /// methods and properties, which are identical to all types of chromosomes.</para></remarks>
  ///
  TChromosomeBase = class(TInterfacedObject,IChromosome,IComparable)
      /// <summary>
      /// Chromosome's fintess value.
      /// </summary>
      protected FFitness : Double;
   public
      procedure Generate;                    virtual;abstract;
      function  CreateNew: IChromosome;      virtual;abstract;
      function  Clone:IChromosome ;          virtual;abstract;
      procedure Mutate;                      virtual;abstract;
      procedure Crossover(var pair: IChromosome);virtual;abstract;
      function  Fitness: Double;
      procedure Evaluate(fun :IFitnessFunction );
      function  CompareTo( o: TObject ): Integer;
  end;

  /// <summary>
  /// Binary chromosome, which supports length from 2 till 64.
  /// </summary>
  ///
  /// <remarks><para>The binary chromosome is the simplest type of chromosomes,
  /// which is represented by a set of bits. Maximum number of bits comprising
  /// the chromosome is 64.</para></remarks>
  ///
  TBinaryChromosome  = class(TChromosomeBase)
   protected
      /// <summary>
      /// Chromosome's length in bits.
      /// </summary>
      FLength : Integer;

      /// <summary>
      /// Numerical chromosome's value.
      /// </summary>
      FValue : UInt64;

      /// <summary>
      /// Chromosome's maximum length.
      /// </summary>
      ///
      /// <remarks><para>Maxim chromosome's length in bits, which is supported
      /// by the class</para></remarks>
      ///
      FMaxLength : Integer;
   public
      constructor Create(nLength: Integer);overload ;
      constructor Create(source: TBinaryChromosome );overload;
      function    GetValue: UInt64;
      function    GetMaxValue: UInt64;
      function    ToString: String;override;
      procedure   Generate;override;
      function    CreateNew: IChromosome; override;
      function    Clone:IChromosome; override;
      procedure   Mutate; override;
      procedure   Crossover(var pair: IChromosome); override;
      // Proprietà
      property  MaxLength : Integer       read  FMaxLength ;
      property  MaxValue  : UInt64        read  GetMaxValue ;
      property  nLength   : Integer       read  FLength ;
      property  Value     : UInt64        read  GetValue    write FValue;
  end;

  /// <summary>
  /// Short array chromosome.
  /// </summary>
  ///
  /// <remarks><para>Short array chromosome represents array of unsigned short values.
  /// Array length is in the range of [2, 65536].
  /// </para></remarks>
  //
  TShortArrayChromosome  = class(TChromosomeBase)
   protected
      /// <summary>
      /// Chromosome's length in number of elements.
      /// </summary>
      FLength : Integer;

      /// <summary>
      /// Chromosome's value.
      /// </summary>
      FValue : AWord ;

      /// <summary>
      ///Maximum value of chromosome's gene (element).
      /// </summary>
      FMaxValue : Integer;

      /// <summary>
      /// Chromosome's maximum length.
      /// </summary>
      ///
      /// <remarks><para>Maxim chromosome's length in array elements.</para></remarks>
      ///
      FMaxLength  : Integer;
   public
      constructor Create(nLength : Integer; nMaxValue: integer = 65536);overload;
      constructor Create(source: TShortArrayChromosome );overload;
      function    ToString: String;override;
      procedure   Generate;override;
      function    CreateNew: IChromosome; override;
      function    Clone:IChromosome; override;
      procedure   Mutate; override;
      procedure   Crossover(var pair: IChromosome); override;
      // Proprietà
      property  MaxLength : Integer       read  FMaxLength ;
      property  MaxValue  : Integer       read  FMaxValue ;
      property  nLength   : Integer       read  FLength ;
      property  Value     : AWord         read  FValue     write FValue;
  end;

  /// <summary>
	/// Permutation chromosome.
  /// </summary>
  ///
  /// <remarks><para>Permutation chromosome is based on short array chromosome,
  /// but has two features:</para>
  /// <list type="bullet">
  /// <item>all genes are unique within chromosome, i.e. there are no two genes
  /// with the same value;</item>
  /// <item>maximum value of each gene is equal to chromosome length minus 1.</item>
  /// </list>
  /// </remarks>
  ///
  TPermutationChromosome  = class(TShortArrayChromosome)
   private
      procedure CreateChildUsingCrossover( parent1, parent2, child : AWord )  ;
      function  CreateIndexDictionary(genes : AWord): AWord;
   public
      constructor Create(nLength : integer);overload;
      constructor Create(source: TPermutationChromosome );overload;
      procedure   Generate;override;
      function    CreateNew: IChromosome; override;
      function    Clone:IChromosome; override;
      procedure   Mutate; override;
      procedure   Crossover(var pair: IChromosome); override;
  end;

  /// <summary>
  /// Double array chromosome.
  /// </summary>
  ///
  /// <remarks><para>Double array chromosome represents array of double values.
  /// Array length is in the range of [2, 65536].
  /// </para>
  ///
  /// <para>See documentation to <see cref="Mutate"/> and <see cref="Crossover"/> methods
  /// for information regarding implemented mutation and crossover operators.</para>
  /// </remarks>
  ///
  TDoubleArrayChromosome  = class(TChromosomeBase)
    private
      /// <summary>
      /// Chromosome's maximum length.
      /// </summary>
      ///
      /// <remarks><para>Maxim chromosome's length in array elements.</para></remarks>
      ///
      FMaxLength : Integer;

      /// <summary>
      /// Chromosome's length in number of elements.
      /// </summary>
      Flength : Integer;

      /// <summary>
      /// Mutation balancer to control mutation type, [0, 1].
      /// </summary>
      ///
      /// <remarks><para>The property controls type of mutation, which is used more
      /// frequently. A radnom number is generated each time before doing mutation -
      /// if the random number is smaller than the specified balance value, then one
      /// mutation type is used, otherwse another. See <see cref="Mutate"/> method
      /// for more information.</para>
      ///
      /// <para>Default value is set to <b>0.5</b>.</para>
      /// </remarks>
      ///
      FMutatBal: Double;

      /// <summary>
      /// Crossover balancer to control crossover type, [0, 1].
      /// </summary>
      ///
      /// <remarks><para>The property controls type of crossover, which is used more
      /// frequently. A radnom number is generated each time before doing crossover -
      /// if the random number is smaller than the specified balance value, then one
      /// crossover type is used, otherwse another. See <see cref="Crossover"/> method
      /// for more information.</para>
      ///
      /// <para>Default value is set to <b>0.5</b>.</para>
      /// </remarks>
      ///
      FCrossBal: Double;
      procedure SetCrossBal(const Value: Double);
      procedure SetMutatBal(const Value: Double);
    protected
      /// <summary>
      /// Chromosome generator.
      /// </summary>
      ///
      /// <remarks><para>This random number generator is used to initialize chromosome's genes,
      /// which is done by calling <see cref="Generate"/> method.</para></remarks>
      ///
      FChromosomeGenerator : IRandomNumberGenerator;

      /// <summary>
      /// Mutation multiplier generator.
      /// </summary>
      ///
      /// <remarks><para>This random number generator is used to generate random multiplier values,
      /// which are used to multiply chromosome's genes during mutation.</para></remarks>
      ///
      FMutationMultiplierGenerator: IRandomNumberGenerator;

      /// <summary>
      /// Mutation addition generator.
      /// </summary>
      ///
      /// <remarks><para>This random number generator is used to generate random addition values,
      /// which are used to add to chromosome's genes during mutation.</para></remarks>
      ///
      FMutationAdditionGenerator: IRandomNumberGenerator;

      /// <summary>
      /// Chromosome's value.
      /// </summary>
      FValue : ADouble;
    public
      constructor Create(chromosomeGenerator,mutationMultiplierGenerator, mutationAdditionGenerator: IRandomNumberGenerator; nLength: Integer);overload;
      constructor Create(chromosomeGenerator,mutationMultiplierGenerator, mutationAdditionGenerator: IRandomNumberGenerator; aValues: ADouble);overload;
      constructor Create(source: TDoubleArrayChromosome );overload;
      function    ToString: String;override;
      procedure   Generate;override;
      function    CreateNew: IChromosome; override;
      function    Clone:IChromosome; override;
      procedure   Mutate; override;
      procedure   Crossover(var pair: IChromosome); override;
      // Proprietà
      property  MaxLength : Integer       read  FMaxLength ;
      property  nLength   : Integer       read  FLength ;
      property  Value     : ADouble       read  FValue;
      property  MutatBal  : Double        read  FMutatBal    write SetMutatBal;
      property  CrossBal  : Double        read  FCrossBal    write SetCrossBal;
      property  ChromosomeGenerator         : IRandomNumberGenerator read FChromosomeGenerator ;
      property  MutationMultiplierGenerator : IRandomNumberGenerator read FMutationMultiplierGenerator ;
      property  MutationAdditionGenerator   : IRandomNumberGenerator read FMutationAdditionGenerator ;
  end;

  //*****************************Classi Fitness Function
  (******************************************************)

  /// <summary>Base class for one dimensional function optimizations.</summary>
  ///
  /// <remarks><para>The class is aimed to be used for one dimensional function
  /// optimization problems. It implements all methods of <see cref="IFitnessFunction"/>
  /// interface and requires overriding only one method -
  /// <see cref="OptimizationFunction"/>, which represents the
  /// function to optimize.</para>
  ///
  /// <para><note>The optimization function should be greater
  /// than 0 on the specified optimization range.</note></para>
  ///
  /// <para>The class works only with binary chromosomes (<see cref="BinaryChromosome"/>).</para>
  ///
  /// <para>Sample usage:</para>
  /// <code>
  /// // define optimization function
  /// public class UserFunction : OptimizationFunction1D
  /// {
  ///	    public UserFunction( ) :
  ///         base( new Range( 0, 255 ) ) { }
  ///
  /// 	public override double OptimizationFunction( double x )
  ///		{
  ///			return Math.Cos( x / 23 ) * Math.Sin( x / 50 ) + 2;
  ///		}
  /// }
  /// ...
  /// // create genetic population
  /// Population population = new Population( 40,
  ///		new BinaryChromosome( 32 ),
  ///		new UserFunction( ),
  ///		new EliteSelection( ) );
  ///
  /// while ( true )
  /// {
  ///	    // run one epoch of the population
  ///     population.RunEpoch( );
  ///     // ...
  /// }
  /// </code>
  /// </remarks>
  ///
  TOptimizationFunction1D = class(TInterfacedObject,IFitnessFunction)
  private
    FRange : TRange;
    FMode  : Modes;
  public
    constructor Create(Range: TRange);
    function Evaluate(chromosome : IChromosome ): Double;
    function Translate( chromosome : IChromosome ): Double;
    function OptimizationFunction( x: Double ): Double;virtual; abstract;
    property Range : TRange  read FRange write FRange;
    property Mode  : Modes  read FMode  write FMode;
  end;
  /// <summary>Base class for two dimenstional function optimization.</summary>
  ///
  /// <remarks><para>The class is aimed to be used for two dimensional function
  /// optimization problems. It implements all methods of <see cref="IFitnessFunction"/>
  /// interface and requires overriding only one method -
  /// <see cref="OptimizationFunction"/>, which represents the
  /// function to optimize.</para>
  ///
  /// <para><note>The optimization function should be greater
  /// than 0 on the specified optimization range.</note></para>
  ///
  /// <para>The class works only with binary chromosomes (<see cref="BinaryChromosome"/>).</para>
  ///
  /// <para>Sample usage:</para>
  /// <code>
  /// // define optimization function
  /// public class UserFunction : OptimizationFunction2D
  /// {
  ///		public UserFunction( ) :
  ///			base( new Range( -4, 4 ), new Range( -4, 4 ) ) { }
  ///
  /// 	public override double OptimizationFunction( double x, double y )
  ///		{
  ///			return ( Math.Cos( y ) * x * y ) / ( 2 - Math.Sin( x ) );
  ///		}
  /// }
  /// ...
  /// // create genetic population
  /// Population population = new Population( 40,
  ///		new BinaryChromosome( 32 ),
  ///		new UserFunction( ),
  ///		new EliteSelection( ) );
  ///	// run one epoch of the population
  ///	population.RunEpoch( );
  /// </code>
  /// </remarks>
  ///
  TOptimizationFunction2D = class(TInterfacedObject,IFitnessFunction)
  private
    FRangeX: TRange;
    FRangeY: TRange;
    FMode  : Modes;
  public
    constructor Create(RangeX,RangeY: TRange);
    function Evaluate(chromosome : IChromosome ): Double;
    function Translate( chromosome : IChromosome ): ADouble;

    /// <summary>
    /// Function to optimize.
    /// </summary>
    ///
    /// <param name="x">Function X input value.</param>
    /// <param name="y">Function Y input value.</param>
    ///
    /// <returns>Returns function output value.</returns>
    ///
    /// <remarks>The method should be overloaded by inherited class to
    /// specify the optimization function.</remarks>
    ///
    function OptimizationFunction( x,y: Double ): Double;virtual; abstract;
    property RangeX : TRange  read FRangeX write FRangeX;
    property RangeY : TRange  read FRangeY write FRangeY;
    property Mode   : Modes   read FMode   write FMode;
  end;

  /// <summary>
  /// Fitness function for symbolic regression (function approximation) problem
  /// </summary>
  ///
  /// <remarks><para>The fitness function calculates fitness value of
  /// <see cref="GPTreeChromosome">GP</see> and <see cref="GEPChromosome">GEP</see>
  /// chromosomes with the aim of solving symbolic regression problem. The fitness function's
  /// value is computed as:
  /// <code>100.0 / ( error + 1 )</code>
  /// where <b>error</b> equals to the sum of absolute differences between function values (computed using
  /// the function encoded by chromosome) and input values (function to be approximated).</para>
  ///
  /// <para>Sample usage:</para>
  /// <code>
  ///	// constants
  ///	double[] constants = new double[5] { 1, 2, 3, 5, 7 };
  ///	// function to be approximated
  ///	double[,] data = new double[5, 2] {
  ///		{1, 1}, {2, 3}, {3, 6}, {4, 10}, {5, 15} };
  ///	// create population
  ///	Population population = new Population( 100,
  ///		new GPTreeChromosome( new SimpleGeneFunction( 1 + constants.Length ) ),
  ///		new SymbolicRegressionFitness( data, constants ),
  ///		new EliteSelection( ) );
  ///	// run one epoch of the population
  ///	population.RunEpoch( );
  /// </code>
  /// </remarks>
  ///
  TSymbolicRegressionFitness = class(TInterfacedObject,IFitnessFunction)
  private
    FData    : AADouble;
    FVariable: ADouble;
  public
    constructor Create(data: AADouble; constants: ADouble);
    Function Evaluate(chromosome : IChromosome ): Double;
    function Translate( chromosome : IChromosome ): string;
  end;

  /// <summary>
	/// Fitness function for times series prediction problem
	/// </summary>
	///
	/// <remarks><para>The fitness function calculates fitness value of
	/// <see cref="GPTreeChromosome">GP</see> and <see cref="GEPChromosome">GEP</see>
	/// chromosomes with the aim of solving times series prediction problem using
	/// sliding window method. The fitness function's value is computed as:
	/// <code>100.0 / ( error + 1 )</code>
	/// where <b>error</b> equals to the sum of absolute differences between predicted value
  /// and actual future value.</para>
  ///
  /// <para>Sample usage:</para>
  /// <code>
  /// // number of points from the past used to predict new one
  /// int windowSize = 5;
  ///	// time series to predict
  ///	double[] data = new double[13] { 1, 2, 4, 7, 11, 16, 22, 29, 37, 46, 56, 67, 79 };
  ///	// constants
  ///	double[] constants = new double[10] { 1, 2, 3, 5, 7, 11, 13, 17, 19, 23 };
  ///	// create population
  ///	Population population = new Population( 100,
  ///	new GPTreeChromosome( new SimpleGeneFunction( windowSize + constants.Length ) ),
  ///	new TimeSeriesPredictionFitness( data, windowSize, 1, constants ),
  ///	new EliteSelection( ) );
  ///	// run one epoch of the population
  ///	population.RunEpoch( );
  /// </code>
  /// </remarks>
	///
  TTimeSeriesPredictionFitness = class(TInterfacedObject,IFitnessFunction)
  private
    FData          : ADouble;  // time series data
    FVariable      : ADouble;  // varibles
    FWindowSize    : integer;  // window size
    FPredictionSize: Integer;  // prediction size
  public
    constructor Create(data: ADouble; windowSize, predictionSize : Integer; constants: ADouble);
    Function Evaluate(chromosome : IChromosome ): Double;
    function Translate( chromosome : IChromosome ): string;
  end;

implementation

{ TChromosomeBase }

/// <summary>
/// Compare two chromosomes.
/// </summary>
///
/// <param name="o">Binary chromosome to compare to.</param>
///
/// <returns>Returns comparison result, which equals to 0 if fitness values
/// of both chromosomes are equal, 1 if fitness value of this chromosome
/// is less than fitness value of the specified chromosome, -1 otherwise.</returns>
///
function TChromosomeBase.CompareTo(o: TObject): Integer;
(********************************************************)
var
  f : Double;
begin
      f := TChromosomeBase(o).fitness;
      if      FFitness = f then   Result := 0
      else if FFitness < f then   Result := 1
      else                        Result := -1

end;

/// <summary>
/// Evaluate chromosome with specified fitness function.
/// </summary>
///
/// <param name="function">Fitness function to use for evaluation of the chromosome.</param>
///
/// <remarks><para>Calculates chromosome's fitness using the specifed fitness function.</para></remarks>
///
procedure TChromosomeBase.Evaluate(fun: IFitnessFunction);
(********************************************************)
begin
      FFitness := fun.Evaluate( Self  );
end;

/// <summary>
/// Chromosome's fintess value.
/// </summary>
///
/// <remarks><para>Fitness value (usefulness) of the chromosome calculate by calling
/// <see cref="Evaluate"/> method. The greater the value, the more useful the chromosome.
/// </para></remarks>
///
function TChromosomeBase.Fitness: Double;
(********************************************************)
begin
      Result := FFitness;
end;

{ TBinaryChromosome }

/// <summary>
/// Initializes a new instance of the <see cref="BinaryChromosome"/> class.
/// </summary>
///
/// <param name="nLength">Chromosome's length in bits, [2, <see cref="MaxLength"/>].</param>
///
constructor TBinaryChromosome.Create(nLength: Integer);
(********************************************************)
begin
     FValue     := 0;
     FMaxLength := 64;
     FFitness   := 0;

     FLength := Max( 2, Min( FMaxLength, nLength ) );
     // randomize the chromosome
     Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="BinaryChromosome"/> class.
/// </summary>
///
/// <param name="source">Source chromosome to copy.</param>
///
/// <remarks><para>This is a copy constructor, which creates the exact copy
/// of specified chromosome.</para></remarks>
///
constructor TBinaryChromosome.Create(source: TBinaryChromosome);
(**************************************************************)
begin
     FValue     := 0;
     FMaxLength := 64;
     FFitness   := 0;

     FLength    := source.nLength;
     FValue     := source.Value;
     FFitness   := source.FFitness;
end;

/// <summary>
/// Max possible chromosome's value.
/// </summary>
///
/// <remarks><para>Maximum possible numerical value, which may be represented
/// by the chromosome of current length.</para></remarks>
///
function TBinaryChromosome.GetMaxValue: UInt64;
(********************************************************)
begin
      Result := $FFFFFFFFFFFFFFFF shr ( 64 - FLength  );
end;

/// <summary>
/// Chromosome's value.
/// </summary>
///
/// <remarks><para>Current numerical value of the chromosome.</para></remarks>
///
function TBinaryChromosome.GetValue: UInt64;
(********************************************************)
begin
     Result := FValue and  ( $FFFFFFFFFFFFFFFF shr ( 64 - FLength ) );
end;

/// <summary>
/// Get string representation of the chromosome.
/// </summary>
///
/// <returns>Returns string representation of the chromosome.</returns>
///
function TBinaryChromosome.ToString: String;
(********************************************************)
var
  tVal : UInt64;
  s    : string;
  i    : Integer;
begin
     tVal := FValue;
     SetLength(s,FLength);
     for i := 1 to FLength do
     begin
          s[i] := chr( tVal and 1 ) ;//+ '0' ;
          tval := tVal shr 1;
     end;
     Result := s;
end;

/// <summary>
/// Generate random chromosome value.
/// </summary>
///
/// <remarks><para>Regenerates chromosome's value using random number generator.</para>
/// </remarks>
///
procedure TBinaryChromosome.Generate;
(********************************************************)
begin
     Randomize;
     PCardinal(@FValue)^               := GetTickCount;
     PCardinal(cardinal(@FValue) + 4)^ := Random(SizeOf(Integer));
end;

/// <summary>
/// Create new random chromosome with same parameters (factory method).
/// </summary>
///
/// <remarks><para>The method creates new chromosome of the same type, but randomly
/// initialized. The method is useful as factory method for those classes, which work
/// with chromosome's interface, but not with particular chromosome type.</para></remarks>
///
function TBinaryChromosome.CreateNew: IChromosome;
(********************************************************)
begin
     Result := TBinaryChromosome.Create(FLength);
end;

/// <summary>
/// Clone the chromosome.
/// </summary>
///
/// <returns>Return's clone of the chromosome.</returns>
///
/// <remarks><para>The method clones the chromosome returning the exact copy of it.</para>
/// </remarks>
///
function TBinaryChromosome.Clone: IChromosome;
(********************************************************)
begin
     Result := TBinaryChromosome.Create(Self);
end;

/// <summary>
/// Mutation operator.
/// </summary>
///
/// <remarks><para>The method performs chromosome's mutation, changing randomly
/// one of its bits.</para></remarks>
///
procedure TBinaryChromosome.Mutate;
(********************************************************)
begin
     Randomize;
     FValue  := FValue xor  (1 shl Random( FLength ) );
end;

/// <summary>
/// Crossover operator.
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
/// <remarks><para>The method performs crossover between two chromosomes – interchanging
/// range of bits between these chromosomes.</para></remarks>
///
procedure TBinaryChromosome.Crossover(var pair: IChromosome);
(********************************************************)
var
  p                : TBinaryChromosome;
  crossOverPoint   : Integer;
  mask1,mask2,V1,V2: UInt64;
begin
     p := TBinaryChromosome(pair);

     // check for correct pair
     if ( p <> Nil ) and ( p.nLength = FLength ) then
     begin
          crossOverPoint := 63 - Random( FLength - 1 );
          mask1          := $FFFFFFFFFFFFFFFF shr crossOverPoint;
          mask2          := not mask1;

          V1 := FValue;
          v2 := p.Value;

          // calculate new values
          FValue   := ( v1 and mask1 ) or ( v2 and mask2 );
          p.Value  := ( v2 and mask1 ) or ( v1 and mask2 );
     end;
end;


{TShortArrayChromosome }

/// <summary>
/// Initializes a new instance of the <see cref="ShortArrayChromosome"/> class.
/// </summary>
///
/// <param name="length">Chromosome's length in array elements, [2, <see cref="MaxLength"/>].</param>
/// <param name="maxValue">Maximum value of chromosome's gene (array element).</param>
///
constructor TShortArrayChromosome.Create(nLength : integer; nMaxValue: integer = 65536);
(*****************************************************************************)
begin
     FMaxLength := 65536;

     FLength   :=  Max( 2, Min( FMaxLength, nLength ) );
     FMaxValue :=  Max( 1, Min( SizeOf(Word), nMaxValue ) );

     SetLength(FValue,FLength);

    // generate random chromosome
    Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="ShortArrayChromosome"/> class.
/// </summary>
///
/// <param name="source">Source chromosome to copy.</param>
///
/// <remarks><para>This is a copy constructor, which creates the exact copy
/// of specified chromosome.</para></remarks>
///
constructor TShortArrayChromosome.Create(source: TShortArrayChromosome);
(**********************************************************************)
begin
      // copy all properties
      FLength   := source.nLength;
      FMaxValue := source.MaxValue;
      FValue    := source.Value;
      FFitness  := source.FFitness;
end;

/// <summary>
/// Get string representation of the chromosome.
/// </summary>
///
/// <returns>Returns string representation of the chromosome.</returns>
///
function TShortArrayChromosome.ToString: String;
(********************************************************)
var
sb : TStringBuilder;
i  : Integer;
begin
     sb := TStringBuilder.Create;

     // append first gene
     sb.Append( FValue[0] );
     // append all other genes
     for i := 1 to FLength do
     begin
          sb.Append( ' ' );
          sb.Append( FValue[i] );
     end;
     Result := sb.ToString;
end;

/// <summary>
/// Generate random chromosome value.
/// </summary>
///
/// <remarks><para>Regenerates chromosome's value using random number generator.</para>
/// </remarks>
///
procedure TShortArrayChromosome.Generate;
(********************************************************)
var
  nMax,i : Integer;

begin
     nMax := FMaxValue + 1;

     for i := 0 to FLength -1 do
        FValue[i] := Word(Random(nMax));
end;

/// <summary>
/// Create new random chromosome with same parameters (factory method).
/// </summary>
///
/// <remarks><para>The method creates new chromosome of the same type, but randomly
/// initialized. The method is useful as factory method for those classes, which work
/// with chromosome's interface, but not with particular chromosome type.</para></remarks>
///
function TShortArrayChromosome.CreateNew: IChromosome;
(********************************************************)
begin
     Result := TShortArrayChromosome.Create(FLength,FMaxValue);
end;

/// <summary>
/// Clone the chromosome.
/// </summary>
///
/// <returns>Return's clone of the chromosome.</returns>
///
/// <remarks><para>The method clones the chromosome returning the exact copy of it.</para>
/// </remarks>
///
function TShortArrayChromosome.Clone: IChromosome;
(********************************************************)
begin
     Result := TShortArrayChromosome.Create(Self);
end;

/// <summary>
/// Mutation operator.
/// </summary>
///
/// <remarks><para>The method performs chromosome's mutation, changing randomly
/// one of its genes (array elements).</para></remarks>
///
procedure TShortArrayChromosome.Mutate;
(********************************************************)
var
  i : Integer;

begin
     // Indice casuale
     i := Random(FLength);

     FValue[i] := Word(Random(FMaxValue + 1));
end;

/// <summary>
/// Crossover operator.
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
/// <remarks><para>The method performs crossover between two chromosomes – interchanging
/// range of genes (array elements) between these chromosomes.</para></remarks>
///
procedure TShortArrayChromosome.Crossover(var pair: IChromosome);
(************************************************************)
var
  p                : TShortArrayChromosome;
  crossOverPoint,
  crossOverLength   : Integer;
  temp              : AWord;
begin
     p := TShortArrayChromosome(pair);

     // check for correct pair
     if ( p <> Nil ) and ( p.nLength = FLength ) then
     begin
          // crossover point
          crossOverPoint := Random( FLength - 1 ) + 1;
          // length of chromosome to be crossed
          crossOverLength := FLength - crossOverPoint;
          // temporary array
          SetLength(temp,crossOverLength);

          // copy part of first (this) chromosome to temp
          //Array.Copy( FValue, crossOverPoint, temp, 0, crossOverLength );
          CopyMemory(@temp[0], @FValue[crossOverPoint], crossOverLength * SizeOf(word));

          // copy part of second (pair) chromosome to the first
          //Array.Copy( p.Value, crossOverPoint, FValue, crossOverPoint, crossOverLength );
          CopyMemory(@FValue[crossOverPoint], @p.Value[crossOverPoint], crossOverLength * SizeOf(word));

          // copy temp to the second
          //Array.Copy( temp, 0, p.Value, crossOverPoint, crossOverLength );
          CopyMemory(@p.Value[crossOverPoint], @temp[0], crossOverLength * SizeOf(word));
     end;

end;

{ TPermutationChromosome }

/// <summary>
/// Initializes a new instance of the <see cref="PermutationChromosome"/> class.
/// </summary>
constructor TPermutationChromosome.Create(nLength: integer);
(************************************************************)
begin
     inherited Create(nLength, nLength - 1);
end;

/// <summary>
/// Initializes a new instance of the <see cref="PermutationChromosome"/> class.
/// </summary>
///
/// <param name="source">Source chromosome to copy.</param>
///
/// <remarks><para>This is a copy constructor, which creates the exact copy
/// of specified chromosome.</para></remarks>
///
constructor TPermutationChromosome.Create(source: TPermutationChromosome);
(************************************************************************)
begin
     inherited Create(source);
end;

procedure TPermutationChromosome.Generate;
(************************************************************)
var
  i,n, j1,j2 : Integer;
  t         : Word;
begin
     // create ascending permutation initially
		 for i := 0 to FLength-1 do
			 FValue[i] := Word(i);

			// shufle the permutation
      n := FLength shr 1;
			for i := 0 to n do
			begin
           j1 := Random(FLength );
				   j2 := Random(FLength );

				// swap values
				t		       := FValue[j1];
				FValue[j1] := FValue[j2];
				FValue[j2] := t;
			end;

end;

/// <summary>
/// Create new random chromosome with same parameters (factory method).
/// </summary>
///
/// <remarks><para>The method creates new chromosome of the same type, but randomly
/// initialized. The method is useful as factory method for those classes, which work
/// with chromosome's interface, but not with particular chromosome type.</para></remarks>
///
function TPermutationChromosome.CreateNew: IChromosome;
(************************************************************)
begin
     Result := TPermutationChromosome.Create(FLength);
end;

/// <summary>
/// Clone the chromosome.
/// </summary>
///
/// <returns>Return's clone of the chromosome.</returns>
///
/// <remarks><para>The method clones the chromosome returning the exact copy of it.</para>
/// </remarks>
///
function TPermutationChromosome.Clone: IChromosome;
(************************************************************)
begin
    Result := TPermutationChromosome.Create(Self);
end;

/// <summary>
/// Mutation operator.
/// </summary>
///
/// <remarks><para>The method performs chromosome's mutation, swapping two randomly
/// chosen genes (array elements).</para></remarks>
///
procedure TPermutationChromosome.Mutate;
(************************************************************)
var
  j1,j2 : Integer;
  t     : Word;
begin
     j1 := Random(FLength );
		 j2 := Random(FLength );

		 // swap values
		 t		      := FValue[j1];
		 FValue[j1] := FValue[j2];
		 FValue[j2] := t;

end;

/// <summary>
/// Crossover operator.
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
/// <remarks><para>The method performs crossover between two chromosomes – interchanging
/// some parts between these chromosomes.</para></remarks>
///
procedure TPermutationChromosome.Crossover(var pair: IChromosome);
(************************************************************)
var
  p              : TPermutationChromosome;
  child1,child2  : AWord;
begin
     p := TPermutationChromosome(pair);

     // check for correct pair
     if ( p <> Nil ) and ( p.nLength = FLength ) then
     begin
          SetLength(child1, FLength);
				  SetLength(child2, FLength);

				  // create two children
				  CreateChildUsingCrossover( FValue, p.Value, child1 );
				  CreateChildUsingCrossover( p.Value, FValue, child2 );

				  // replace parents with children
				  FValue  := child1;
				  p.Value := child2;
     end;

end;

// Produce new child applying crossover to two parents
procedure TPermutationChromosome.CreateChildUsingCrossover(parent1, parent2, child: AWord);
(*******************************************************************************************)
var
  indexDictionary1,
  indexDictionary2 : AWord;
  geneIsBusy : array of Boolean;
  valid1, valid2 : Boolean;
  prev, next1, next2  : Word;
  j, k ,i,r: Integer;
begin
     indexDictionary1 := CreateIndexDictionary( parent1 );
     indexDictionary2 := CreateIndexDictionary( parent2 );
     // temporary array to specify if certain gene already  present in the child
     SetLength(geneIsBusy,FLength);
     k := FLength - 1;  //j := k ;
     // first gene of the child is taken from the second parent
     child[0]         := parent2[0];
		 prev             := child[0] ;
		 geneIsBusy[prev] := true;

     // resolve all other genes of the child
			for i := 1 to FLength - 1 do
      begin
           // find the next gene after PREV in both parents
				   // 1
           j := indexDictionary1[prev];
           if   j = k then next1 := parent1[0]
           else            next1 := parent1[j + 1];
           // 2
           j := indexDictionary2[prev];
           if   j = k then next2 := parent2[0]
           else            next2 := parent2[j + 1];

				   // check candidate genes for validness
				   valid1 := not geneIsBusy[next1];
				   valid2 := not geneIsBusy[next2];
           // select gene
				   if  valid1 and  valid2  then
				   begin
					      // both candidates are valid
					      // select one of theme randomly
                if Random(2)  =  0 then prev := next1
                else                    prev := next2;
           end
           else if ( not ( valid1 or valid2 ) )  then
				   begin
               // none of candidates is valid, so
					     // select random gene which is not in the child yet
               j := Random(FLength);
               r := j ;
               // go down first
				       while ( ( r < FLength ) and ( geneIsBusy[r] = True ) )  do  Inc(r);

               if  r = FLength then
               begin
                     // not found, try to go up
					           r := j - 1;
						         while ( geneIsBusy[r] = True )	do	Dec(r);
               end;
               prev := Word(r);
           end else
           begin
             // one of candidates is valid
             if   valid1 then prev := next1
             else             prev := next2
           end;
           child[i]         := prev;
				   geneIsBusy[prev] := True;
      end;


end;

 // Create dictionary for fast lookup of genes' indexes
function TPermutationChromosome.CreateIndexDictionary(genes: AWord): AWord;
(**************************************************************************)
var
  indexDictionary : AWord;
  i               : Integer;
begin
      SetLength(indexDictionary,High(genes)+1);

      for i := 0 to High(genes) do
         indexDictionary[genes[i]] := Word(i);


      Result :=  indexDictionary;
end;

{ TDoubleArrayChromosome }

/// <summary>
/// Initializes a new instance of the <see cref="DoubleArrayChromosome"/> class.
/// </summary>
///
/// <param name="chromosomeGenerator">Chromosome generator - random number generator, which is
/// used to initialize chromosome's genes, which is done by calling <see cref="Generate"/> method
/// or in class constructor.</param>
/// <param name="mutationMultiplierGenerator">Mutation multiplier generator - random number
/// generator, which is used to generate random multiplier values, which are used to
/// multiply chromosome's genes during mutation.</param>
/// <param name="mutationAdditionGenerator">Mutation addition generator - random number
/// generator, which is used to generate random addition values, which are used to
/// add to chromosome's genes during mutation.</param>
/// <param name="length">Chromosome's length in array elements, [2, <see cref="MaxLength"/>].</param>
///
/// <remarks><para>The constructor initializes the new chromosome randomly by calling
/// <see cref="Generate"/> method.</para></remarks>
///
constructor TDoubleArrayChromosome.Create(chromosomeGenerator, mutationMultiplierGenerator,
  mutationAdditionGenerator: IRandomNumberGenerator; nLength: Integer);
(**********************************************************************************************)
begin
     FMutatBal := 0.5;
     FCrossBal := 0.5;
     FMaxLength:= 65536;

     // save parameters
     FchromosomeGenerator         := chromosomeGenerator;
     FMutationMultiplierGenerator := mutationMultiplierGenerator;
     FmutationAdditionGenerator   := mutationAdditionGenerator;
     FLength                      := Max( 2, Min( FMaxLength, nLength ) ); ;

     // allocate array
     SetLength(FValue, FLength);

     // generate random chromosome
     Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="DoubleArrayChromosome"/> class.
/// </summary>
///
/// <param name="chromosomeGenerator">Chromosome generator - random number generator, which is
/// used to initialize chromosome's genes, which is done by calling <see cref="Generate"/> method
/// or in class constructor.</param>
/// <param name="mutationMultiplierGenerator">Mutation multiplier generator - random number
/// generator, which is used to generate random multiplier values, which are used to
/// multiply chromosome's genes during mutation.</param>
/// <param name="mutationAdditionGenerator">Mutation addition generator - random number
/// generator, which is used to generate random addition values, which are used to
/// add to chromosome's genes during mutation.</param>
/// <param name="values">Values used to initialize the chromosome.</param>
///
/// <remarks><para>The constructor initializes the new chromosome with specified <paramref name="values">values</paramref>.
/// </para></remarks>
///
/// <exception cref="ArgumentOutOfRangeException">Invalid length of values array.</exception>
///
constructor TDoubleArrayChromosome.Create(chromosomeGenerator, mutationMultiplierGenerator,
  mutationAdditionGenerator: IRandomNumberGenerator; aValues: ADouble);
(**********************************************************************************************)
begin
     FMutatBal := 0.5;
     FCrossBal := 0.5;
     FMaxLength:= 65536;

     if  (Length(aValues) < 2)  or  (Length(aValues) > MaxLength)  then
                raise  Exception.Create( 'Invalid length of values array.' );

     // save parameters
     FchromosomeGenerator         := chromosomeGenerator;
     FMutationMultiplierGenerator := mutationMultiplierGenerator;
     FmutationAdditionGenerator   := mutationAdditionGenerator;
     FLength                      := Length(aValues);

     // copy specified values
     FValue := aValues;
end;

/// <summary>
/// Initializes a new instance of the <see cref="DoubleArrayChromosome"/> class.
/// </summary>
///
/// <param name="source">Source chromosome to copy.</param>
///
/// <remarks><para>This is a copy constructor, which creates the exact copy
/// of specified chromosome.</para></remarks>
///
constructor TDoubleArrayChromosome.Create(source: TDoubleArrayChromosome);
(**************************************************************************)
begin
    FChromosomeGenerator         := source.chromosomeGenerator;
    FMutationMultiplierGenerator := source.mutationMultiplierGenerator;
    FMutationAdditionGenerator   := source.mutationAdditionGenerator;
    FLength                      := source.nLength;
    FFitness                     := source.fitness;
    FMutatBal                    := source.MutatBal;
    FCrossBal                    := source.crossBal;

    // copy genes
    FValue := source.Value;
end;

/// <summary>
/// Get string representation of the chromosome.
/// </summary>
///
/// <returns>Returns string representation of the chromosome.</returns>
///
function TDoubleArrayChromosome.ToString: String;
(************************************************************)
var
sb : TStringBuilder;
i  : Integer;
begin
     sb := TStringBuilder.Create;

     // append first gene
     sb.Append( FValue[0] );
     // append all other genes
     for i := 1 to FLength do
     begin
          sb.Append( ' ' );
          sb.Append( FValue[i] );
     end;
     Result := sb.ToString;

end;

/// <summary>
/// Generate random chromosome value.
/// </summary>
///
/// <remarks><para>Regenerates chromosome's value using random number generator.</para>
/// </remarks>
///
procedure TDoubleArrayChromosome.Generate;
(************************************************************)
var
  i : Integer;
begin
     for i := 0 to FLength - 1 do
       // generate next value
       FValue[i] := FChromosomeGenerator.NextDouble;

end;

/// <summary>
/// Create new random chromosome with same parameters (factory method).
/// </summary>
///
/// <remarks><para>The method creates new chromosome of the same type, but randomly
/// initialized. The method is useful as factory method for those classes, which work
/// with chromosome's interface, but not with particular chromosome type.</para></remarks>
///
function TDoubleArrayChromosome.CreateNew: IChromosome;
(************************************************************)
begin
     Result := TDoubleArrayChromosome.Create(FChromosomeGenerator, FMutationMultiplierGenerator, FMutationAdditionGenerator, FLength );
end;

// <summary>
/// Clone the chromosome.
/// </summary>
///
/// <returns>Return's clone of the chromosome.</returns>
///
/// <remarks><para>The method clones the chromosome returning the exact copy of it.</para>
/// </remarks>
///
function TDoubleArrayChromosome.Clone: IChromosome;
(************************************************************)
begin
     Result := TDoubleArrayChromosome.Create(Self );
end;

/// <summary>
/// Mutation operator.
/// </summary>
///
/// <remarks><para>The method performs chromosome's mutation, adding random number
/// to chromosome's gene or multiplying the gene by random number. These random
/// numbers are generated with help of <see cref="mutationMultiplierGenerator">mutation
/// multiplier</see> and <see cref="mutationAdditionGenerator">mutation
/// addition</see> generators.</para>
///
/// <para>The exact type of mutation applied to the particular gene
/// is selected randomly each time and depends on <see cref="MutationBalancer"/>.
/// Before mutation is done a random number is generated in [0, 1] range - if the
/// random number is smaller than <see cref="MutationBalancer"/>, then multiplication
/// mutation is done, otherwise addition mutation.
/// </para></remarks>
///
procedure TDoubleArrayChromosome.Mutate;
(************************************************************)
var
   mutationGene : Integer;
begin
     mutationGene := Random(FLength);

     if ( Random < FMutatBal ) then
         FValue[mutationGene] :=  FValue[mutationGene] * mutationMultiplierGenerator.NextDouble
     else
         FValue[mutationGene] :=  FValue[mutationGene] + mutationAdditionGenerator.NextDouble;
end;

/// <summary>
/// Crossover operator.
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
/// <remarks><para>The method performs crossover between two chromosomes, selecting
/// randomly the exact type of crossover to perform, which depends on <see cref="CrossoverBalancer"/>.
/// Before crossover is done a random number is generated in [0, 1] range - if the
/// random number is smaller than <see cref="CrossoverBalancer"/>, then the first crossover
/// type is used, otherwise second type is used.</para>
///
/// <para>The <b>first crossover type</b> is based on interchanging
/// range of genes (array elements) between these chromosomes and is known
/// as one point crossover. A crossover point is selected randomly and chromosomes
/// interchange genes, which start from the selected point.</para>
///
/// <para>The <b>second crossover type</b> is aimed to produce one child, which genes'
/// values are between corresponding genes of parents, and another child, which genes'
/// values are outside of the range formed by corresponding genes of parents.
/// Let take, for example, two genes with 1.0 and 3.0 valueû (of course chromosomes have
/// more genes, but for simplicity lets think about one). First of all we randomly choose
/// a factor in the [0, 1] range, let's take 0.4. Then, for each pair of genes (we have
/// one pair) we calculate difference value, which is 2.0 in our case. In the result we’ll
/// have two children – one between and one outside of the range formed by parents genes' values.
/// We may have 1.8 and 3.8 children, or we may have 0.2 and 2.2 children. As we can see
/// we add/subtract (chosen randomly) <i>difference * factor</i>. So, this gives us exploration
/// in between and in near outside. The randomly chosen factor is applied to all genes
/// of the chromosomes participating in crossover.</para>
/// </remarks>
///
procedure TDoubleArrayChromosome.Crossover(var pair: IChromosome);
(************************************************************)
var
  p                : TDoubleArrayChromosome;
  crossOverPoint,
  crossOverLength,i: Integer;
  temp,pairVal     : ADouble;
  factor,portion   : Double;
begin
     p := TDoubleArrayChromosome(pair);

     // check for correct pair
     if ( p <> Nil ) and ( p.nLength = FLength ) then
     begin
          if ( Random < FCrossBal ) then
          begin
              // crossover point
              crossOverPoint := Random( FLength - 1 ) + 1;
              // length of chromosome to be crossed
              crossOverLength := FLength - crossOverPoint;
              // temporary array
              SetLength(temp,crossOverLength);

              // copy part of first (this) chromosome to temp
              CopyMemory(@temp[0], @FValue[crossOverPoint], crossOverLength * SizeOf(Double));

              // copy part of second (pair) chromosome to the first
              CopyMemory(@FValue[crossOverPoint], @p.Value[crossOverPoint], crossOverLength * SizeOf(Double));

              // copy temp to the second
              CopyMemory(@p.Value[crossOverPoint], @temp[0], crossOverLength * SizeOf(Double));
          end else
          begin
               pairVal := p.Value;
               factor := Random;
               if Random(2) = 0  then  factor := -factor;

               for i := 0 to FLength- 1 do
               begin
                     portion   := ( FValue[i] - pairVal[i] ) * factor;
                     FValue[i] := FValue[i] - portion;
                     pairVal[i]:= pairVal[i] + portion;
               end;
          end;
     end;

end;

procedure TDoubleArrayChromosome.SetCrossBal(const Value: Double);
(******************************************************************)
begin
     FCrossBal := Max( 0.0, Min( 1.0, Value ) )
end;

procedure TDoubleArrayChromosome.SetMutatBal(const Value: Double);
(******************************************************************)
begin
    FMutatBal := Max( 0.0, Min( 1.0, Value ) )
end;

//*****************************Classi Fitness Function
(******************************************************)
{ TOptimizationFunction1D }

/// <summary>
/// Initializes a new instance of the <see cref="OptimizationFunction1D"/> class.
/// </summary>
///
/// <param name="range">Specifies range for optimization.</param>
///
constructor TOptimizationFunction1D.Create(Range: TRange);
(***********************************************************)
begin
     FRange.Range( 0, 1 );
     // optimization mode
     FMode  := omMaximization;
     FRange := Range
end;

/// <summary>
/// Evaluates chromosome.
/// </summary>
///
/// <param name="chromosome">Chromosome to evaluate.</param>
///
/// <returns>Returns chromosome's fitness value.</returns>
///
/// <remarks>The method calculates fitness value of the specified
/// chromosome.</remarks>
///
function TOptimizationFunction1D.Evaluate(chromosome: IChromosome): Double;
(******************************************************************************)
var
  functionValue : Double;
begin
     functionValue := OptimizationFunction( Translate( chromosome ) );
     // fitness value
     if FMode  = omMaximization then Result := functionValue
     else                            Result := 1 / functionValue;

end;

/// <summary>
/// Translates genotype to phenotype.
/// </summary>
///
/// <param name="chromosome">Chromosome, which genoteype should be
/// translated to phenotype.</param>
///
/// <returns>Returns chromosome's fenotype - the actual solution
/// encoded by the chromosome.</returns>
///
/// <remarks>The method returns double value, which represents function's
/// input point encoded by the specified chromosome.</remarks>
///
function TOptimizationFunction1D.Translate(chromosome: IChromosome): Double;
(**************************************************************************)
var
  nVal,Max : Double;
begin
     // get chromosome's value and max value
     nval := TBinaryChromosome(chromosome).Value;
     max  := TBinaryChromosome(chromosome).MaxValue;

     // translate to optimization's funtion space
     Result := nVal * FRange.nLength / max + FRange.Min;
end;

{ TOptimizationFunction2D }

/// <summary>
/// Initializes a new instance of the <see cref="OptimizationFunction2D"/> class.
/// </summary>
///
/// <param name="rangeX">Specifies X variable's range.</param>
/// <param name="rangeY">Specifies Y variable's range.</param>
///
constructor TOptimizationFunction2D.Create(RangeX, RangeY: TRange);
(*******************************************************************)
begin
     FRangeX.Range( 0, 1 );
     FRangeY.Range( 0, 1 );
     // optimization mode
     FMode   := omMaximization;
     FRangeX := RangeX ;
     FRangeY := RangeY
end;

/// <summary>
/// Evaluates chromosome.
/// </summary>
///
/// <param name="chromosome">Chromosome to evaluate.</param>
///
/// <returns>Returns chromosome's fitness value.</returns>
///
/// <remarks>The method calculates fitness value of the specified
/// chromosome.</remarks>
///
function TOptimizationFunction2D.Evaluate(chromosome: IChromosome): Double;
(****************************************************************************)
var
   xy            : ADouble;
   functionValue : Double;
begin
     // do native translation first
     xy := Translate( chromosome );
     // get function value
     functionValue := OptimizationFunction( xy[0], xy[1] );
     // return fitness value
     if FMode  = omMaximization then Result := functionValue
     else                            Result := 1 / functionValue;

end;

/// <summary>
/// Translates genotype to phenotype
/// </summary>
///
/// <param name="chromosome">Chromosome, which genoteype should be
/// translated to phenotype</param>
///
/// <returns>Returns chromosome's fenotype - the actual solution
/// encoded by the chromosome</returns>
///
/// <remarks>The method returns array of two double values, which
/// represent function's input point (X and Y) encoded by the specified
/// chromosome.</remarks>
///
function TOptimizationFunction2D.Translate(chromosome: IChromosome): ADouble;
(***************************************************************************)
var
  nVal,xMax,yMax          : UInt64;
  nLength,xLength,yLength : Integer;
  xPart,yPart             : double;
  ret                     : ADouble;
begin
    // get chromosome's value
    nVal    := TBinaryChromosome(chromosome).Value;
    // chromosome's length
    nLength := TBinaryChromosome(chromosome).nLength;
    // length of X component
    xLength := nLength div 2;
    // length of Y component
    yLength := nLength - xLength;
    // X maximum value - equal to X mask
    xMax    := $FFFFFFFFFFFFFFFF shr ( 64 - xLength );
    // Y maximum value
    yMax    := $FFFFFFFFFFFFFFFF shr ( 64 - yLength );
    // X component
    xPart   := nVal and xMax;
    // Y component;
    yPart   := nVal shr xLength;

    // translate to optimization's funtion space
    SetLength(ret,2);

    ret[0] := xPart * rangeX.nLength / xMax + rangeX.Min;
    ret[1] := yPart * rangeY.nLength / yMax + rangeY.Min;

    Result := ret;
end;


{ TSymbolicRegressionFitness }

// <summary>
/// Initializes a new instance of the <see cref="SymbolicRegressionFitness"/> class.
/// </summary>
///
/// <param name="data">Function to be approximated.</param>
/// <param name="constants">Array of constants to be used as additional
/// paramters for genetic expression.</param>
///
/// <remarks><para>The <paramref name="data"/> parameter defines the function to be approximated and
/// represents a two dimensional array of (x, y) points.</para>
///
/// <para>The <paramref name="constants"/> parameter is an array of constants, which can be used as
/// additional variables for a genetic expression. The actual amount of variables for
/// genetic expression equals to the amount of constants plus one - the <b>x</b> variable.</para>
/// </remarks>
///
constructor TSymbolicRegressionFitness.Create(data: AADouble; constants: ADouble);
(***********************************************************************************)
begin
     FData := data;
     // copy constants
     SetLength(FVariable, Length(constants)+1);
     CopyMemory(@FVariable[1], @constants[0], Length(constants) * SizeOf(Double));
end;

/// <summary>
/// Evaluates chromosome.
/// </summary>
///
/// <param name="chromosome">Chromosome to evaluate.</param>
///
/// <returns>Returns chromosome's fitness value.</returns>
///
/// <remarks>The method calculates fitness value of the specified
/// chromosome.</remarks>
///
function TSymbolicRegressionFitness.Evaluate(chromosome: IChromosome): Double;
(********************************************************************************)
var
  sFun   : string;
  error,y: double;
  i      : Integer;
begin
     Result := 0;
     // get function in polish notation
     sFun := chromosome.ToString;
     // go through all the data
     error := 0.0;
     for  i := 0 to  Length(FData[0]) - 1 do
     begin
          // put next X value to variables list
          FVariable[0] := FData[i, 0];
          // avoid evaluation errors
          try
             // evalue the function
             { TODO -oPigreco -c :  PolishExpression.Evaluate 05/05/2013 10:59:44 }
             //y = PolishExpression.Evaluate( sFun, FVariable );
             // check for correct numeric value
             if IsNaN( y ) then
             begin
                  Result := 0;
                  Exit;
             end;
             // get the difference between evaluated Y and real Y  and sum error
             error := error + Abs( y - FData[i, 1] );
          Except
             Exit;
          end;
          // return optimization function value
          Result := 100.0 / ( error + 1 );

     end;
end;

/// <summary>
/// Translates genotype to phenotype .
/// </summary>
///
/// <param name="chromosome">Chromosome, which genoteype should be
/// translated to phenotype.</param>
///
/// <returns>Returns chromosome's fenotype - the actual solution
/// encoded by the chromosome.</returns>
///
/// <remarks>The method returns string value, which represents approximation
/// expression written in polish postfix notation.</remarks>
///
function TSymbolicRegressionFitness.Translate(chromosome: IChromosome): string;
(*****************************************************************************)
begin
     // return polish notation for now ...
     Result := chromosome.ToString;
end;

{ TTimeSeriesPredictionFitness }

/// <summary>
/// Initializes a new instance of the <see cref="TimeSeriesPredictionFitness"/> class.
/// </summary>
///
/// <param name="data">Time series to be predicted.</param>
/// <param name="windowSize">Window size - number of past samples used
/// to predict future value.</param>
/// <param name="predictionSize">Prediction size - number of values to be predicted. These
/// values are excluded from training set.</param>
/// <param name="constants">Array of constants to be used as additional
/// paramters for genetic expression.</param>
///
/// <remarks><para>The <paramref name="data"/> parameter is a one dimensional array, which defines times
/// series to predict. The amount of learning samples is equal to the number of samples
/// in the provided time series, minus window size, minus prediction size.</para>
///
/// <para>The <paramref name="predictionSize"/> parameter specifies the amount of samples, which should
/// be excluded from training set. This set of samples may be used for future verification
/// of the prediction model.</para>
///
/// <para>The <paramref name="constants"/> parameter is an array of constants, which can be used as
/// additional variables for a genetic expression. The actual amount of variables for
/// genetic expression equals to the amount of constants plus the window size.</para>
/// </remarks>
///
constructor TTimeSeriesPredictionFitness.Create(data: ADouble; windowSize, predictionSize: Integer; constants: ADouble);
(************************************************************************************************************************)
begin
     // check for correct parameters
			if  windowSize >= Length(FData) then
          raise Exception.Create('Window size should be less then data amount');

			if  Length(FData) - windowSize - predictionSize < 1 then
          raise Exception.Create('Data size should be enough for window and prediction');

			// save parameters
			FData			     := data;
			FWindowSize		 := windowSize;
			FPredictionSize:= predictionSize;
			// copy constants
      SetLength(FVariable, Length(constants)+ windowSize);
      CopyMemory(@FVariable[windowSize], @constants[0], Length(constants) * SizeOf(Double));
end;

/// <summary>
/// Evaluates chromosome.
/// </summary>
///
/// <param name="chromosome">Chromosome to evaluate.</param>
///
/// <returns>Returns chromosome's fitness value.</returns>
///
/// <remarks>The method calculates fitness value of the specified
/// chromosome.</remarks>
///
function TTimeSeriesPredictionFitness.Evaluate(chromosome: IChromosome): Double;
(******************************************************************************)
var
  sFun   : string;
  error,y: double;
  i,n,j,b: Integer;
begin
     Result := 0;
     // get function in polish notation
     sFun := chromosome.ToString;
     // go through all the data
     error := 0.0;
     n     := Length(FData) - FWindowSize - FPredictionSize;
     for  i := 0 to  n - 1 do
     begin
          // put values from current window as variables
          b := i + FWindowSize - 1;
          for j := 0 to FWindowSize - 1 do
          begin
               FVariable[j] := FData[b - j];
          end;
          // avoid evaluation errors
          try
             // evalue the function
             { TODO -oPigreco -c :  PolishExpression.Evaluate 05/05/2013 10:59:44 }
             //y = PolishExpression.Evaluate( sFun, FVariable );
             // check for correct numeric value
             if IsNaN( y ) then
             begin
                  Result := 0;
                  Exit;
             end;
             // get the difference between evaluated Y and real Y  and sum error
             error := error + Abs( y - FData[i + FWindowSize] );
          Except
             Exit;
          end;
          // return optimization function value
          Result := 100.0 / ( error + 1 );
     end;
end;


/// <summary>
/// Translates genotype to phenotype.
/// </summary>
///
/// <param name="chromosome">Chromosome, which genoteype should be
/// translated to phenotype.</param>
///
/// <returns>Returns chromosome's fenotype - the actual solution
/// encoded by the chromosome.</returns>
///
/// <remarks><para>The method returns string value, which represents prediction
/// expression written in polish postfix notation.</para>
///
/// <para>The interpretation of the prediction expression is very simple. For example, let's
/// take a look at sample expression, which was received with window size equal to 5:
/// <code lang="none">$0 $1 - $5 / $2 *</code>
/// The above expression in postfix polish notation should be interpreted as a next expression:
/// <code lang="none">( ( x[t - 1] - x[t - 2] ) / const1 ) * x[t - 3]</code>
/// </para>
/// </remarks>
///
function TTimeSeriesPredictionFitness.Translate(chromosome: IChromosome): string;
(*******************************************************************************)
begin
     // return polish notation for now ...
     Result := chromosome.ToString;
end;

end.
