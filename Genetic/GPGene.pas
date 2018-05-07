// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit GPGene;

interface
uses
  Windows, Messages, SysUtils, Classes,System.Math,NeuralNetDef,Cromosomi,
  System.Generics.Collections;

type
  /// <summary>
  /// Enumeration of supported functions.
  /// </summary>
  FFunctions = ( fAdd, fSubtract, fMultiply, fDivide);

  /// <summary>
  /// Enumeration of supported functions.
  /// </summary>
  FFunctionsExt = ( fxAdd, fxSubtract, fxMultiply, fxDivide,fxSin,fxCos,fxLn,fxExp,fxSqrt);

  /// <summary>
  /// Genetic Programming's gene interface.
  /// </summary>
  ///
  /// <remarks><para>This is a gene interface, which is used for building chromosomes
  /// in Genetic Programming (GP) and Gene Expression Programming (GEP).
  /// </para></remarks>
  ///
  IGPGene = interface
    ['{66B61370-4ACC-405B-8A35-408E4767F82D}']

      /// <summary>
      /// Gene type.
      /// </summary>
      ///
      /// <remarks><para>The property represents type of a gene - function, argument, etc.</para>
      /// </remarks>
      ///
      function  GetGeneType:GPGeneType;

      /// <summary>
      /// Arguments count.
      /// </summary>
      ///
      /// <remarks><para>Arguments count of a particular function gene.</para></remarks>
      ///
      function GetArgumentsCount: Integer;

      /// <summary>
      /// Maximum arguments count.
      /// </summary>
      ///
      /// <remarks><para>Maximum arguments count of a function gene. The property may be used
      /// by chromosomes' classes to allocate correctly memory for functions' arguments,
      /// for example.</para></remarks>
      ///
      function GetMaxArgumentsCount: Integer;

      /// <summary>
      /// Clone gene.
      /// </summary>
      ///
      /// <remarks><para>The method clones gene returning the exact copy of it.</para></remarks>
      ///
      function Clone:IGPGene;

      /// <summary>
      /// Randomize gene with random type and value.
      /// </summary>
      ///
      /// <remarks><para>The method randomizes a gene, setting its type and value randomly.</para></remarks>
      ///
      procedure Generate; overload;

      /// <summary>
      /// Randomize gene with random value.
      /// </summary>
      ///
      /// <param name="type">Gene type to set.</param>
      ///
      /// <remarks><para>The method randomizes a gene, setting its value randomly, but type
      /// is set to the specified one.</para></remarks>
      ///
      procedure Generate( tipo: GPGeneType ); overload;

      /// <summary>
      /// Creates new gene with random type and value.
      /// </summary>
      ///
      /// <remarks><para>The method creates new randomly initialized gene .
      /// The method is useful as factory method for those classes, which work with gene's interface,
      /// but not with particular gene class.</para>
      /// </remarks>
      ///
      function CreateNew: IGPGene; overload;

      /// <summary>
      /// Creates new gene with certain type and random value.
      /// </summary>
      ///
      /// <param name="type">Gene type to create.</param>
      ///
      /// <remarks><para>The method creates new gene with specified type, but random value.
      /// The method is useful as factory method for those classes, which work with gene's interface,
      /// but not with particular gene class.</para>
      /// </remarks>
      ///
      function CreateNew(Tipo: GPGeneType ): IGPGene; overload;
  end;
  AGPGene = array of IGPGene;

  /// <summary>
  /// Genetic programming gene, which represents simple arithmetic functions and arguments.
  /// </summary>
  ///
  /// <remarks><para>Simple gene function may represent an arithmetic function (+, -, *, /) or
  /// an argument to function. This class is used by Genetic Programming (or Gene Expression Programming)
  /// chromosomes to build arbitrary expressions with help of genetic operators.</para>
  /// </remarks>
  ///
  TSimpleGeneFunction = class(TInterfacedObject,IGPGene)
  private
     FFunctionsCount : Integer;
     FTipo           : GPGeneType ;
     FVariablesCount : Integer;
     FValue          : Integer ;
     constructor InternalCreate(variablesCount : Integer; bRandom: Boolean );
     function    GetArgumentsCount: Integer;
     function    GetGeneType: GPGeneType;
     function    GetMaxArgumentsCount: Integer;
  public
    constructor Create(variablesCount : Integer); overload;
    constructor Create(variablesCount : Integer; Tipo:GPGeneType ); overload;
    function    ToString : string;override;
    function    Clone:IGPGene;
    procedure   Generate; overload;
    procedure   Generate( tipo: GPGeneType );overload;
    function    CreateNew: IGPGene; overload;
    function    CreateNew(Tipo: GPGeneType ): IGPGene; overload;
    //Proprietà
    property Value            : Integer      read FValue;
    property Tipo             : GPGeneType   read GetGeneType;
    property ArgumentsCount   : Integer      read GetArgumentsCount;
    property MaxArgumentsCount: Integer      read GetMaxArgumentsCount;
  end;

  /// <summary>
  /// Genetic programming gene, which represents arithmetic functions, common mathematical functions
  /// and arguments.
  /// </summary>
  ///
  /// <remarks><para>Extended gene function may represent arithmetic functions (+, -, *, /),
  /// some common mathematical functions (sin, cos, ln, exp, sqrt) or an argument to functions.
  /// This class is used by Genetic Programming (or Gene Expression Programming)
  /// chromosomes to build arbitrary expressions with help of genetic operators.</para>
  /// </remarks>
  ///
  TExtendedGeneFunction = class(TInterfacedObject,IGPGene)
  private
     FFunctionsCount : Integer;
     FTipo           : GPGeneType ;
     FVariablesCount : Integer;
     FArgumentsCount : Integer;
     FValue          : Integer ;
     constructor InternalCreate(variablesCount : Integer; bRandom: Boolean );
     function    GetArgumentsCount: Integer;
     function    GetGeneType: GPGeneType;
     function    GetMaxArgumentsCount: Integer;
  public
    constructor Create(variablesCount : Integer); overload;
    constructor Create(variablesCount : Integer; Tipo:GPGeneType ); overload;
    function    ToString : string;override;
    function    Clone:IGPGene;
    procedure   Generate; overload;
    procedure   Generate( tipo: GPGeneType );overload;
    function    CreateNew: IGPGene; overload;
    function    CreateNew(Tipo: GPGeneType ): IGPGene; overload;
    //Proprietà
    property Value            : Integer      read FValue;
    property Tipo             : GPGeneType   read GetGeneType;
    property ArgumentsCount   : Integer      read GetArgumentsCount;
    property MaxArgumentsCount: Integer      read GetMaxArgumentsCount;
  end;

  /// <summary>
  /// Represents tree node of genetic programming tree.
  /// </summary>
  ///
  /// <remarks><para>In genetic programming a chromosome is represented by a tree, which
  /// is represented by <see cref="GPTreeChromosome"/> class. The <see cref="GPTreeNode"/>
  /// class represents single node of such genetic programming tree.</para>
  ///
  /// <para>Each node may or may not have children. This means that particular node of a genetic
  /// programming tree may represent its sub tree or even entire tree.</para>
  /// </remarks>
  ///
  TGPTreeNode = class(TObject)
  private
      /// <summary>
      /// Gene represented by the chromosome.
      /// </summary>
      FGene: IGPGene;

      /// <summary>
      /// List of node's children.
      /// </summary>
      FChildren : TList<TGPTreeNode> ;

      constructor Create; overload;
  public
      constructor Create( gene:IGPGene);overload;
      function    ToString: string;override;
      function    Clone: TObject;
      //Proprietà
      property Gene      : IGPGene            read FGene;
      property Children  : TList<TGPTreeNode> read FChildren;
  end;


  /// <summary>
  /// The chromosome represents a Gene Expression, which is used for
  /// different tasks of Genetic Expression Programming (GEP).
  /// </summary>
  ///
  /// <remarks><para>This type of chromosome represents combination of ideas taken from
  /// Genetic Algorithms (GA), where chromosomes are linear structures of fixed length, and
  /// Genetic Programming (GP), where chromosomes are expression trees. The GEP chromosome
  /// is also a fixed length linear structure, but with some additional features which
  /// make it possible to generate valid expression tree from any GEP chromosome.</para>
  ///
  /// <para>The theory of Gene Expression Programming is well described in the next paper:
  /// <b>Ferreira, C., 2001. Gene Expression Programming: A New Adaptive Algorithm for Solving
  /// Problems. Complex Systems, Vol. 13, issue 2: 87-129</b>. A copy of the paper may be
  /// obtained on the
  /// <a href="http://www.gene-expression-programming.com/">gene expression programming</a> web site.</para>
  /// </remarks>
  ///
  TGEPChromosome  = class(TChromosomeBase)
  protected
    /// <summary>
    /// Length of GEP chromosome's head.
    /// </summary>
    ///
    /// <remarks><para>GEP chromosome's head is a part of chromosome, which may contain both
    /// functions' and arguments' nodes. The rest of chromosome (tail) may contain only arguments' nodes.
    /// </para></remarks>
    ///
    FheadLength : Integer;

    /// <summary>
    /// GEP chromosome's length.
    /// </summary>
    ///
    /// <remarks><para><note>The variable keeps chromosome's length, but not expression length represented by the
    /// chromosome.</note></para></remarks>
    ///
    Fnlength : Integer;

    /// <summary>
    /// Array of chromosome's genes.
    /// </summary>
    FGenes : AGPGene;
    function  GetTree: TGPTreeNode;
    procedure MutateGene;
    procedure TransposeIS;
    procedure TransposeRoot;
    procedure Recombine(src1,src2 : AGPGene; point, length: Integer );
  public
    constructor Create(ancestor: IGPGene; headLength: Integer);overload;
    constructor Create(source: TGEPChromosome);overload;
    function    ToString: String;override;
    function    ToStringNative: String;
    procedure   Generate;override;
    function    CreateNew: IChromosome; override;
    function    Clone:IChromosome; override;
    procedure   Mutate; override;
    procedure   Crossover(var pair: IChromosome); override;
    procedure   RecombinationOnePoint(pair: TGEPChromosome ) ;
    procedure   RecombinationTwoPoint(pair: TGEPChromosome );
    //proprietà
    property headLength : Integer   read FheadLength ;
    property nlength    : Integer   read Fnlength ;
    property Genes      : AGPGene   read FGenes;
  end;

  /// <summary>
  /// Tree chromosome represents a tree of genes, which is is used for
  /// different tasks of Genetic Programming (GP).
  /// </summary>
  ///
  /// <remarks><para>This type of chromosome represents a tree, where each node
  /// is represented by <see cref="GPTreeNode"/> containing <see cref="IGPGene"/>.
  /// Depending on type of genes used to build the tree, it may represent different
  /// types of expressions aimed to solve different type of tasks. For example, a
  /// particular implementation of <see cref="IGPGene"/> interface may represent
  /// simple algebraic operations and their arguments.
  /// </para>
  ///
  /// <para>See documentation to <see cref="IGPGene"/> implementations for additional
  /// information about possible Genetic Programming trees.</para>
  /// </remarks>
  ///
  TGPTreeChromosome  = class(TChromosomeBase)
  private
    FRoot             : TGPTreeNode ;   // tree root
    FMaxInitialLevel  : Integer;        // maximum initial level of the tree
    FMaxLevel         : Integer;        // maximum level of the tree
    function  RandomSwap(source: TGPTreeNode ): TGPTreeNode;
    procedure Trim(node: TGPTreeNode; level: Integer ) ;
    procedure SetMaxInitialLevel(const Value: Integer);
    procedure SetMaxLevel(const Value: Integer);
  public
    constructor Create(ancestor: IGPGene);overload;
    constructor Create(source: TGPTreeChromosome);overload;
    function    ToString: String;override;
    procedure   Generate;overload; override;
    procedure   Generate(node: TGPTreeNode; level: Integer);overload;
    function    CreateNew: IChromosome; override;
    function    Clone:IChromosome; override;
    procedure   Mutate; override;
    procedure   Crossover(var pair: IChromosome); override;

    /// <summary>
    /// Maximum initial level of genetic trees, [1, 25].
    /// </summary>
    ///
    /// <remarks><para>The property sets maximum possible initial depth of new
    /// genetic programming tree. For example, if it is set to 1, then largest initial
    /// tree may have a root and one level of children.</para>
    ///
    /// <para>Default value is set to <b>3</b>.</para>
    /// </remarks>
    ///
    property  MaxInitialLevel  : Integer  read FMaxInitialLevel write SetMaxInitialLevel;

    /// <summary>
    /// Maximum level of genetic trees, [1, 50].
    /// </summary>
    ///
    /// <remarks><para>The property sets maximum possible depth of
    /// genetic programming tree, which may be created with mutation and crossover operators.
    /// This property guarantees that genetic programmin tree will never have
    /// higher depth, than the specified value.</para>
    ///
    /// <para>Default value is set to <b>5</b>.</para>
    /// </remarks>
    ///
    property  MaxLevel         : Integer  read FMaxLevel        write SetMaxLevel;
  end;

implementation


{ TSimpleGeneFunction }

// Private constructor
constructor TSimpleGeneFunction.InternalCreate(variablesCount: Integer; bRandom: Boolean);
(****************************************************************************************)
begin
     FFunctionsCount := 4 ;
     FVariablesCount := variablesCount;
     // generate the gene value
     if  bRandom then Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="SimpleGeneFunction"/> class.
/// </summary>
///
/// <param name="variablesCount">Total amount of variables in the task which is supposed
/// to be solved.</param>
///
/// <remarks><para>The constructor creates randomly initialized gene with random type
/// and value by calling <see cref="Generate( )"/> method.</para></remarks>
///
constructor TSimpleGeneFunction.Create(variablesCount: Integer);
(****************************************************************)
begin
     InternalCreate(variablesCount,True)
end;

/// <summary>
/// Initializes a new instance of the <see cref="SimpleGeneFunction"/> class.
/// </summary>
///
/// <param name="variablesCount">Total amount of variables in the task which is supposed
/// to be solved.</param>
/// <param name="Tipo">Gene type to set.</param>
///
/// <remarks><para>The constructor creates randomly initialized gene with random
/// value and preset gene type.</para></remarks>
///
constructor TSimpleGeneFunction.Create(variablesCount: Integer; Tipo: GPGeneType);
(********************************************************************************)
begin
     FFunctionsCount := 4 ;
     FVariablesCount := variablesCount;
     // generate the gene value
     Generate( Tipo )
end;

/// <summary>
/// Get string representation of the gene.
/// </summary>
///
/// <returns>Returns string representation of the gene.</returns>
///
function TSimpleGeneFunction.ToString: string;
(******************************************************)
begin
     if FTipo = gtFunction then
     begin
          case FFunctions(FValue) of
                fAdd     :	Result := '+';
                fSubtract:	Result := '-';
                fMultiply:	Result := '*';
                fDivide  :  Result := '/';
          end;
     end
     else Result :=Format( '${%x}',[FValue] );
end;

// <summary>
/// Clone the gene.
/// </summary>
///
/// <remarks><para>The method clones the chromosome returning the exact copy of it.</para></remarks>
///
function TSimpleGeneFunction.Clone: IGPGene;
(******************************************************)
begin
    // create new gene ...
    Result := TSimpleGeneFunction.InternalCreate( FVariablesCount, False );
    // ... with the same type and value
    TSimpleGeneFunction(Result).FTipo  := FTipo;
    TSimpleGeneFunction(Result).FValue := FValue;

end;

/// <summary>
/// Randomize gene with random type and value.
/// </summary>
///
/// <remarks><para>The method randomizes the gene, setting its type and value randomly.</para></remarks>
///
procedure TSimpleGeneFunction.Generate;
(******************************************************)
begin
     // give more chance to function
     if Random(4) = 3 then  Generate(gtArgument)
     else                   Generate(gtFunction)
end;

/// <summary>
/// Randomize gene with random value.
/// </summary>
///
/// <param name="type">Gene type to set.</param>
///
/// <remarks><para>The method randomizes a gene, setting its value randomly, but type
/// is set to the specified one.</para></remarks>
///
procedure TSimpleGeneFunction.Generate(tipo: GPGeneType);
(******************************************************)
begin
     // gene type
     FTipo := tipo;
     // gene value
     if FTipo = gtFunction then  FValue := Random(FFunctionsCount)
     else                        FValue := Random(FVariablesCount)
end;

/// <summary>
/// Creates new gene with random type and value.
/// </summary>
///
/// <remarks><para>The method creates new randomly initialized gene .
/// The method is useful as factory method for those classes, which work with gene's interface,
/// but not with particular gene class.</para>
/// </remarks>
///
function TSimpleGeneFunction.CreateNew: IGPGene;
(******************************************************)
begin
    Result := TSimpleGeneFunction.Create( FVariablesCount );
end;

/// <summary>
/// Creates new gene with certain type and random value.
/// </summary>
///
/// <param name="type">Gene type to create.</param>
///
/// <remarks><para>The method creates new gene with specified type, but random value.
/// The method is useful as factory method for those classes, which work with gene's interface,
/// but not with particular gene class.</para>
/// </remarks>
///
function TSimpleGeneFunction.CreateNew(Tipo: GPGeneType): IGPGene;
(****************************************************************)
begin
     Result := TSimpleGeneFunction.Create( FVariablesCount, Tipo );
end;

function TSimpleGeneFunction.GetArgumentsCount: Integer;
(******************************************************)
begin
      if FTipo = gtArgument then Result := 0
      else                       Result := 2;
end;

function TSimpleGeneFunction.GetGeneType: GPGeneType;
(******************************************************)
begin
     Result := FTipo
end;

function TSimpleGeneFunction.GetMaxArgumentsCount: Integer;
(******************************************************)
begin
    Result := 2;
end;

{ TExtendedGeneFunction }

// Private constructor
constructor TExtendedGeneFunction.InternalCreate(variablesCount: Integer; bRandom: Boolean);
(****************************************************************************************)
begin
     FFunctionsCount := 9 ;
     FArgumentsCount := 0;
     FVariablesCount := variablesCount;
     // generate the gene value
     if  bRandom then Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="ExtendedGeneFunction"/> class.
/// </summary>
///
/// <param name="variablesCount">Total amount of variables in the task which is supposed
/// to be solved.</param>
///
/// <remarks><para>The constructor creates randomly initialized gene with random type
/// and value by calling <see cref="Generate( )"/> method.</para></remarks>
///
constructor TExtendedGeneFunction.Create(variablesCount: Integer);
(****************************************************************)
begin
     InternalCreate(variablesCount,True)
end;

/// <summary>
/// Initializes a new instance of the <see cref="ExtendedGeneFunction"/> class.
/// </summary>
///
/// <param name="variablesCount">Total amount of variables in the task which is supposed
/// to be solved.</param>
/// <param name="type">Gene type to set.</param>
///
/// <remarks><para>The constructor creates randomly initialized gene with random
/// value and preset gene type.</para></remarks>
///
constructor TExtendedGeneFunction.Create(variablesCount: Integer; Tipo: GPGeneType);
(********************************************************************************)
begin
     FFunctionsCount := 4 ;
     FArgumentsCount := 0;
     FVariablesCount := variablesCount;
     // generate the gene value
     Generate( Tipo )
end;

/// <summary>
/// Get string representation of the gene.
/// </summary>
///
/// <returns>Returns string representation of the gene.</returns>
///
function TExtendedGeneFunction.ToString: string;
(******************************************************)
begin
     if FTipo = gtFunction then
     begin
          case FFunctionsExt(FValue) of
                fxAdd     :	Result := '+';
                fxSubtract:	Result := '-';
                fxMultiply:	Result := '*';
                fxDivide  : Result := '/';
                fxSin     :	Result := 'sin';
                fxCos     :	Result := 'cos';
                fxLn      : Result := 'ln';
                fxExp     :	Result := 'Exp';
                fxSqrt    : Result := 'sqrt';
          end;
     end
     else Result :=Format( '${%x}',[FValue] );
end;

/// <summary>
/// Clone the gene.
/// </summary>
///
/// <remarks><para>The method clones the chromosome returning the exact copy of it.</para></remarks>
///
function TExtendedGeneFunction.Clone: IGPGene;
(******************************************************)
begin
    // create new gene ...
    Result := TExtendedGeneFunction.InternalCreate( FVariablesCount, False );
    // ... with the same type and value
    TExtendedGeneFunction(Result).FTipo  := FTipo;
    TExtendedGeneFunction(Result).FValue := FValue;
    TExtendedGeneFunction(Result).FArgumentsCount := FArgumentsCount;

end;

/// <summary>
/// Randomize gene with random type and value.
/// </summary>
///
/// <remarks><para>The method randomizes the gene, setting its type and value randomly.</para></remarks>
///
procedure TExtendedGeneFunction.Generate;
(******************************************************)
begin
     // give more chance to function
     if Random(4) = 3 then  Generate(gtArgument)
     else                   Generate(gtFunction)
end;

/// <summary>
/// Randomize gene with random value.
/// </summary>
///
/// <param name="type">Gene type to set.</param>
///
/// <remarks><para>The method randomizes a gene, setting its value randomly, but type
/// is set to the specified one.</para></remarks>
///
procedure TExtendedGeneFunction.Generate(tipo: GPGeneType);
(******************************************************)
begin
     // gene type
     FTipo := tipo;
     // gene value
     if FTipo = gtFunction then  FValue := Random(FFunctionsCount)
     else                        FValue := Random(FVariablesCount);

     if FTipo = gtArgument then
         FArgumentsCount := 0
     else
         if FValue <= Ord(FFunctionsExt(fxDivide)) then  FArgumentsCount := 2
         else                                            FArgumentsCount := 1


end;

/// <summary>
/// Creates new gene with random type and value.
/// </summary>
///
/// <remarks><para>The method creates new randomly initialized gene .
/// The method is useful as factory method for those classes, which work with gene's interface,
/// but not with particular gene class.</para>
/// </remarks>
///
function TExtendedGeneFunction.CreateNew: IGPGene;
(******************************************************)
begin
    Result := TExtendedGeneFunction.Create( FVariablesCount );
end;

/// <summary>
/// Creates new gene with certain type and random value.
/// </summary>
///
/// <param name="type">Gene type to create.</param>
///
/// <remarks><para>The method creates new gene with specified type, but random value.
/// The method is useful as factory method for those classes, which work with gene's interface,
/// but not with particular gene class.</para>
/// </remarks>
///
function TExtendedGeneFunction.CreateNew(Tipo: GPGeneType): IGPGene;
(****************************************************************)
begin
     Result := TExtendedGeneFunction.Create( FVariablesCount, Tipo );
end;

function TExtendedGeneFunction.GetArgumentsCount: Integer;
(******************************************************)
begin
      Result := FArgumentsCount;
end;

function TExtendedGeneFunction.GetGeneType: GPGeneType;
(******************************************************)
begin
     Result := FTipo
end;

function TExtendedGeneFunction.GetMaxArgumentsCount: Integer;
(******************************************************)
begin
    Result := 2;
end;

{ TGPTreeNode }

/// <summary>
/// Initializes a new instance of the <see cref="GPTreeNode"/> class.
/// </summary>
///
constructor TGPTreeNode.Create;
(****************************************************************)
begin
     inherited create;
end;

/// <summary>
/// Initializes a new instance of the <see cref="GPTreeNode"/> class.
/// </summary>
///
constructor TGPTreeNode.Create(gene: IGPGene);
(****************************************************************)
begin
     FGene := gene
end;

/// <summary>
/// Get string representation of the node.
/// </summary>
///
/// <returns>Returns string representation of the node.</returns>
///
/// <remarks><para>String representation of the node lists all node's children and
/// then the node itself. Such node's string representations equals to
/// its reverse polish notation.</para>
///
/// <para>For example, if nodes value is '+' and its children are '3' and '5', then
/// nodes string representation is "3 5 +".</para>
/// </remarks>
///
function TGPTreeNode.ToString: string;
(****************************************************************)
var
 sb : TStringBuilder ;
 i  : Integer;

begin
     sb := TStringBuilder.Create;

     if ( FChildren <> nil ) then
     begin
          // walk through all nodes
          for i := 0 to FChildren.Count - 1 do
            sb.Append( FChildren[i].ToString );
     end;
     // add gene value
     { TODO -oPigreco -c :  sb.Append( FGene.ToString); 05/05/2013 18:24:18 }
     //sb.Append( FGene.ToString);
     sb.Append( ' ' );

     Result := sb.ToString;
end;

/// <summary>
/// Clone the tree node.
/// </summary>
///
/// <returns>Returns exact clone of the node.</returns>
///
function TGPTreeNode.Clone: TObject;
(****************************************************************)
var
  clone : TGPTreeNode;
  i     : Integer;
begin
     clone := TGPTreeNode.Create;

     // clone gene
     clone.FGene := FGene.Clone;
     // clone its children
     if  FChildren <> nil then
     begin
          clone.FChildren := TList<TGPTreeNode>.Create;
          // clone each child gene
          for i := 0 to Children.Count - 1 do
              clone.Children.Add( TGPTreeNode(Children[i].Clone) );
     end;
     Result := clone;
end;

{ TGEPChromosome }

/// <summary>
/// Initializes a new instance of the <see cref="GEPChromosome"/> class.
/// </summary>
///
/// <param name="ancestor">A gene, which is used as generator for the genetic tree.</param>
/// <param name="headLength">Length of GEP chromosome's head (see <see cref="headLength"/>).</param>
///
/// <remarks><para>This constructor creates a randomly generated GEP chromosome,
/// which has all genes of the same type and properties as the specified <paramref name="ancestor"/>.
/// </para></remarks>
///
constructor TGEPChromosome.Create(ancestor: IGPGene; headLength: Integer);
(************************************************************************)
begin
      // store head length
      FheadLength := headLength;
      // calculate chromosome's length
      Fnlength := headLength + headLength * ( ancestor.GetMaxArgumentsCount - 1 ) + 1;
      // allocate genes array
      SetLength(FGenes,Fnlength);
      // save ancestor as a temporary head
      FGenes[0] := ancestor;
      // generate the chromosome
      Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="GEPChromosome"/> class.
/// </summary>
///
/// <param name="source">Source GEP chromosome to clone from.</param>
///
constructor TGEPChromosome.Create(source: TGEPChromosome);
(****************************************************************)
var
  i : Integer;
begin
     FheadLength := source.headLength;
     FnLength    := source.nLength;
     Ffitness    := source.fitness;
     // allocate genes array
     SetLength(FGenes,Fnlength);
     // copy genes
     for i := 0 to FnLength  - 1 do
        FGenes[i] := source.genes[i].Clone;
end;

/// <summary>
/// Get string representation of the chromosome by providing its expression in
/// reverse polish notation (postfix notation).
/// </summary>
///
/// <returns>Returns string representation of the expression represented by the GEP
/// chromosome.</returns>
///
function TGEPChromosome.ToString: String;
(****************************************************************)
begin
     // return string representation of the chromosomes tree
     Result := GetTree.ToString;
end;

/// <summary>
/// Get string representation of the chromosome.
/// </summary>
///
/// <returns>Returns the chromosome in native linear representation.</returns>
///
/// <remarks><para><note>The method is used for debugging mostly.</note></para></remarks>
///
function TGEPChromosome.ToStringNative: String;
(****************************************************************)
var
  sb : TStringBuilder;
  i  : Integer;
begin
     sb := TStringBuilder.Create;
     for i := 0 to Length(FGenes) do
     begin
          { TODO -oPigreco -c :  sb.Append( FGenes[i].ToString ); 05/05/2013 20:46:07 }
          //sb.Append( FGenes[i].ToString );
          sb.Append( ' ' );
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
procedure TGEPChromosome.Generate;
(****************************************************************)
var
  i : Integer;
begin
     // randomize the root
     FGenes[0].Generate;
     // generate the rest of the head
     for i := 1  to  FHeadLength do
         FGenes[i] := FGenes[0].CreateNew;
     // generate the tail
     for i := FHeadLength to Fnlength do
         FGenes[i] := FGenes[0].CreateNew( gtArgument );

end;

/// <summary>
/// Get tree representation of the chromosome.
/// </summary>
///
/// <returns>Returns expression's tree represented by the chromosome.</returns>
///
/// <remarks><para>The method builds expression's tree for the native linear representation
/// of the GEP chromosome.</para></remarks>
///
function TGEPChromosome.GetTree: TGPTreeNode;
(****************************************************************)
var
   functionNodes : TQueue<TGPTreeNode>;
   root,node,
   parent        : TGPTreeNode;
   i             : Integer;
begin
    // function node queue. the queue contains function node,
    // which requires children. when a function node receives
    // all children, it will be removed from the queue
    functionNodes := TQueue<TGPTreeNode>.Create;

    // create root node
    root := TGPTreeNode.Create( FGenes[0] );

    // check children amount of the root node
    if ( root.Gene.GetArgumentsCount <> 0 ) then
    begin
         root.FChildren := TList<TGPTreeNode>.Create;
        // place the root to the queue
        functionNodes.Enqueue( root );

        // go through genes
        for  i := 1 to FnLength do
        begin
              // create new node
              node := TGPTreeNode.Create( genes[i] );

              // if next gene represents function, place it to the queue
              if ( FGenes[i].GetGeneType = gtFunction ) then
              begin
                   node.FChildren := TList<TGPTreeNode>.Create;
                   functionNodes.Enqueue( node );
              end;

              // get function node from the top of the queue
              parent := functionNodes.Peek;

              // add new node to children of the parent node
              parent.Children.Add( node );

              // remove the parent node from the queue, if it is
              // already complete
              if ( parent.Children.Count = parent.Gene.GetArgumentsCount )  then
              begin
                  functionNodes.Dequeue;
                  // check the queue if it is empty
                  if ( functionNodes.Count = 0 ) then  break;
              end;
        end;
    end;
    // return formed tree
    Result := root;
end;

/// <summary>
/// Create new random chromosome with same parameters (factory method).
/// </summary>
///
/// <remarks><para>The method creates new chromosome of the same type, but randomly
/// initialized. The method is useful as factory method for those classes, which work
/// with chromosome's interface, but not with particular chromosome type.</para></remarks>
///
function TGEPChromosome.CreateNew: IChromosome;
(****************************************************************)
begin
     Result := TGEPChromosome.Create( FGenes[0].Clone, FHeadLength );
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
function TGEPChromosome.Clone: IChromosome;
(****************************************************************)
begin
     Result := TGEPChromosome( Self );
end;

/// <summary>
/// Mutation operator.
/// </summary>
///
/// <remarks><para>The method performs chromosome's mutation by calling on of the methods
/// randomly: <see cref="MutateGene"/>, <see cref="TransposeIS"/>, <see cref="TransposeRoot"/>.
/// </para></remarks>
///
procedure TGEPChromosome.Mutate;
(****************************************************************)
begin
    // randomly choose mutation method
    case  Random(3) of
      0: 	 MutateGene;  	// ordinary gene mutation
      1:	 TransposeIS;	  // IS transposition
      2:	 TransposeRoot	// root transposition
    end;
end;

/// <summary>
/// Usual gene mutation.
/// </summary>
///
/// <remarks><para>The method performs usual gene mutation by randomly changing randomly selected
/// gene.</para></remarks>
///
procedure TGEPChromosome.MutateGene;
(****************************************************************)
var
  mutationPoint : Integer;
begin
     // select random point of mutation
     mutationPoint := Random( FnLength );
     if ( mutationPoint < FHeadLength ) then
     begin
          // genes from head can be randomized freely (type may change)
          FGenes[mutationPoint].Generate;
     end else
     begin
          // genes from tail cannot change their type - they should be always arguments
          FGenes[mutationPoint].Generate( gtArgument );
     end;
end;

/// <summary>
/// Transposition of IS elements (insertion sequence).
/// </summary>
///
/// <remarks><para>The method performs transposition of IS elements by copying randomly selected region
/// of genes into chromosome's head (into randomly selected position). First gene of the chromosome's head
/// is not affected - can not be selected as target point.</para></remarks>
///
procedure TGEPChromosome.TransposeIS;
(****************************************************************)
var
  sourcePoint, i,j,
  maxSourceLength,
  targetPoint,
  maxTargetLength,
  transposonLength  : Integer;
  genesCopy         : AGPGene;
begin
      // select source point (may be any point of the chromosome)
      sourcePoint     := Random( FnLength );
      // calculate maxim source length
      maxSourceLength := FnLength - sourcePoint;
      // select tartget insertion point in the head (except first position)
      targetPoint     := Random( FHeadLength - 1 ) + 1;
      // calculate maximum target length
      maxTargetLength := FHeadLength - targetPoint;
      // select randomly transposon length
      transposonLength := Random( Min( maxTargetLength, maxSourceLength ) ) + 1;
      // genes copy
      SetLength(genesCopy,transposonLength);

      i := sourcePoint ;
      // copy genes from source point
      for j := 0 to transposonLength - 1 do
      begin
           genesCopy[j] := FGenes[i].Clone;
           inc(i)
      end;

      i := targetPoint;
      // copy genes to target point
      for j := 0 to transposonLength - 1 do
      begin
           FGenes[i] := genesCopy[j];
           inc(i);
      end;
end;

 /// <summary>
/// Root transposition.
/// </summary>
///
/// <remarks><para>The method performs root transposition of the GEP chromosome - inserting
/// new root of the chromosome and shifting existing one. The method first of all randomly selects
/// a function gene in chromosome's head - starting point of the sequence to put into chromosome's
/// head. Then it randomly selects the length of the sequence making sure that the entire sequence is
/// located within head. Once the starting point and the length of the sequence are known, it is copied
/// into chromosome's head shifting existing elements in the head.</para>
/// </remarks>
///
procedure TGEPChromosome.TransposeRoot;
(****************************************************************)
var
  sourcePoint, i,j,
  maxSourceLength,
  transposonLength  : Integer;
  genesCopy         : AGPGene;
begin
      // select source point (may be any point in the head of the chromosome)
      sourcePoint := Random( FHeadLength );
      // scan downsrteam the head searching for function gene
      while ( ( FGenes[sourcePoint].GetGeneType <> gtFunction ) and ( sourcePoint < FHeadLength ) ) do
      begin
          Inc(sourcePoint);
      end;
      // return (do nothing) if function gene was not found
      if ( sourcePoint = FHeadLength ) then Exit;

      // calculate maxim source length
      maxSourceLength  := FHeadLength - sourcePoint;
      // select randomly transposon length
      transposonLength := Random( maxSourceLength ) + 1;
      // genes copy
      SetLength(genesCopy,transposonLength);

       i := sourcePoint;
      // copy genes from source point
      for  j := 0  to  transposonLength - 1 do
      begin
          genesCopy[j] := FGenes[i].Clone;
          inc(i);
      end;

      // shift the head
      for i := FHeadLength - 1 downto  transposonLength do
          FGenes[i] := FGenes[i - transposonLength];

      // put new root
      for i := 0  to transposonLength - 1 do
          FGenes[i] := genesCopy[i];

end;

/// <summary>
/// Crossover operator.
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
/// <remarks><para>The method performs one-point or two-point crossover selecting
/// them randomly with equal probability.</para></remarks>
///
procedure TGEPChromosome.Crossover(var pair: IChromosome);
(****************************************************************)
var
  p : TGEPChromosome;
begin
      p := TGEPChromosome(pair);
      // check for correct chromosome
      if  p <> nil then
      begin
          // choose recombination method
          if  Random( 2 ) = 0 then  RecombinationOnePoint( p )
          else                      RecombinationTwoPoint( p );
      end;

end;

/// <summary>
/// One-point recombination (crossover).
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
procedure TGEPChromosome.RecombinationOnePoint(pair: TGEPChromosome);
(****************************************************************)
var
  crossOverPoint,
  crossOverLength : Integer;
begin
    // check for correct pair
    if  pair.nlength = Fnlength then
    begin
        // crossover point
        crossOverPoint  := Random ( Fnlength  - 1 ) + 1;
        // length of chromosome to be crossed
        crossOverLength := Fnlength - crossOverPoint;

        // swap parts of chromosomes
        Recombine( FGenes, pair.genes, crossOverPoint, crossOverLength );
    end;
end;

/// <summary>
/// Two point recombination (crossover).
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
procedure TGEPChromosome.RecombinationTwoPoint(pair: TGEPChromosome);
(****************************************************************)
var
  crossOverPoint,
  crossOverLength : Integer;
begin
    // check for correct pair
    if pair.nLength = FnLength then
    begin
        // crossover point
        crossOverPoint  := Random( Fnlength - 1 ) + 1;
        // length of chromosome to be crossed
        crossOverLength := FnLength - crossOverPoint;

        // if crossover length already equals to 1, then it becomes
        // usual one point crossover. otherwise crossover length
        // also randomly chosen
        if  crossOverLength <> 1 then
            crossOverLength := Random( crossOverLength - 1 ) + 1;

        // swap parts of chromosomes
        Recombine( FGenes, pair.genes, crossOverPoint, crossOverLength );
    end;
end;

/// <summary>
/// Swap parts of two chromosomes.
/// </summary>
///
/// <param name="src1">First chromosome participating in genes' interchange.</param>
/// <param name="src2">Second chromosome participating in genes' interchange.</param>
/// <param name="point">Index of the first gene in the interchange sequence.</param>
/// <param name="length">Length of the interchange sequence - number of genes
/// to interchange.</param>
///
/// <remarks><para>The method performs interchanging of genes between two chromosomes
/// starting from the <paramref name="point"/> position.</para></remarks>
///
procedure TGEPChromosome.Recombine(src1, src2: AGPGene; point, length: Integer);
(******************************************************************************)
var
  temp : AGPGene;
begin
    // temporary array
    SetLength(temp, FnLength);

    // copy part of first chromosome to temp
    CopyMemory(@temp[0], @src1[point], Fnlength * SizeOf(IGPGene));
    // copy part of second chromosome to the first
    CopyMemory(@src1[point], @src2[point], Fnlength * SizeOf(IGPGene));
    // copy temp to the second
    CopyMemory(@src2[point], @temp[0], Fnlength * SizeOf(IGPGene));
end;

{ TGPTreeChromosome }

// <summary>
/// Initializes a new instance of the <see cref="GPTreeChromosome"/> class.
/// </summary>
///
/// <param name="ancestor">A gene, which is used as generator for the genetic tree.</param>
///
/// <remarks><para>This constructor creates a randomly generated genetic tree,
/// which has all genes of the same type and properties as the specified <paramref name="ancestor"/>.
/// </para></remarks>
///
constructor TGPTreeChromosome.Create(ancestor: IGPGene);
(******************************************************************************)
begin
     FRoot            := TGPTreeNode.Create;
     FMaxInitialLevel := 3;
     FMaxLevel        := 5;
     // make the ancestor gene to be as temporary root of the tree
     FRoot.FGene := ancestor.Clone;
     // call tree regeneration function
     Generate;
end;

/// <summary>
/// Initializes a new instance of the <see cref="GPTreeChromosome"/> class.
/// </summary>
///
/// <param name="source">Source genetic tree to clone from.</param>
///
/// <remarks><para>This constructor creates new genetic tree as a copy of the
/// specified <paramref name="source"/> tree.</para></remarks>
///
constructor TGPTreeChromosome.Create(source: TGPTreeChromosome);
(******************************************************************************)
begin
     FMaxInitialLevel := 3;
     FMaxLevel        := 5;
     FRoot            := TGPTreeNode(source.FRoot.Clone);
     Ffitness         := source.fitness;
end;

/// <summary>
/// Get string representation of the chromosome by providing its expression in
/// reverse polish notation (postfix notation).
/// </summary>
///
/// <returns>Returns string representation of the genetic tree.</returns>
///
/// <remarks><para>The method returns string representation of the tree's root node
/// (see <see cref="GPTreeNode.ToString"/>).</para></remarks>
///
function TGPTreeChromosome.ToString: String;
(******************************************************************************)
begin
     Result := FRoot.ToString;
end;

/// <summary>
/// Generate random chromosome value.
/// </summary>
///
/// <remarks><para>Regenerates chromosome's value using random number generator.</para>
/// </remarks>
///
procedure TGPTreeChromosome.Generate;
(******************************************************************************)
var
  i,Count : Integer;
  child   : TGPTreeNode;
begin
    // randomize the root
    FRoot.Gene.Generate;
    // create children
    if FRoot.Gene.GetArgumentsCount <> 0 then
    begin
          FRoot.FChildren := TList<TGPTreeNode>.Create;
          Count           := FRoot.Gene.GetArgumentsCount;
          for i := 0 to Count - 1 do
          begin
              // create new child
              child := TGPTreeNode.Create;
              Generate( child, Random( maxInitialLevel ) );
              // add the new child
              FRoot.Children.Add( child );
          end;
    end;

end;

/// <summary>
/// Generate chromosome's subtree of specified level.
/// </summary>
///
/// <param name="node">Sub tree's node to generate.</param>
/// <param name="level">Sub tree's level to generate.</param>
///
procedure TGPTreeChromosome.Generate(node: TGPTreeNode; level: Integer);
(******************************************************************************)
var
  i,Count : Integer;
  child   : TGPTreeNode;
begin
      // create gene for the node
      if  level = 0 then
      begin
           // the gene should be an argument
           node.FGene := FRoot.Gene.CreateNew( gtArgument );
      end else
      begin
           // the gene can be function or argument
           node.FGene := FRoot.Gene.CreateNew;
      end;

      // add children
      if node.Gene.GetArgumentsCount <> 0 then
      begin
          node.FChildren := TList<TGPTreeNode>.Create;
          Count         := node.Gene.GetArgumentsCount;
          for i := 0 to  Count - 1 do
          begin
              // create new child
              child := TGPTreeNode.Create;
              Generate( child, level - 1 );
              // add the new child
              node.Children.Add( child );
          end;
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
function TGPTreeChromosome.CreateNew: IChromosome;
(******************************************************************************)
begin
     Result := TGPTreeChromosome.Create( FRoot.Gene.Clone );
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
function TGPTreeChromosome.Clone: IChromosome;
(******************************************************************************)
begin
     Result := TGPTreeChromosome( Self );
end;

/// <summary>
/// Mutation operator.
/// </summary>
///
/// <remarks><para>The method performs chromosome's mutation by regenerating tree's
/// randomly selected node.</para></remarks>
///
procedure TGPTreeChromosome.Mutate;
(******************************************************************************)
var
 i,r,
 currentLevel: Integer;
 node,child  : TGPTreeNode;
begin
     // current tree level
     currentLevel := 0;
     // current node
     node := FRoot;

     while True do
     begin
          // regenerate node if it does not have children
          if  node.Children = nil  then
          begin
              if  currentLevel = FMaxLevel  then
              begin
                  // we reached maximum possible level, so the gene
                  // can be an argument only
                  node.Gene.Generate( gtArgument );
              end else
              begin
                  // generate subtree
                  Generate( node, Random( maxLevel - currentLevel ) );
              end;
              break;
          end;

          // if it is a function node, than we need to get a decision, about
          // mutation point - the node itself or one of its children
          r := Random( node.Gene.GetArgumentsCount + 1 );

          if r = node.Gene.GetArgumentsCount then
          begin
               // node itself should be regenerated
               node.Gene.Generate;

               // check current type
               if  node.Gene.GetGeneType = gtArgument then
               begin
                    node.FChildren := nil;
               end  else
               begin
                    // create children's list if it was absent
                    if node.Children = nil then  node.FChildren := TList<TGPTreeNode>.Create;

                    // check for missing or extra children
                    if ( node.Children.Count <> node.Gene.GetArgumentsCount )  then
                    begin
                          if ( node.Children.Count > node.Gene.GetArgumentsCount ) then
                          begin
                              // remove extra children
                              node.Children.DeleteRange( node.Gene.GetArgumentsCount, node.Children.Count - node.Gene.GetArgumentsCount );
                          end else
                          begin
                              // add missing children
                              for i := node.Children.Count to node.Gene.GetArgumentsCount - 1 do
                              begin
                                  // create new child
                                  child := TGPTreeNode.Create;
                                  Generate( child, Random( maxLevel - currentLevel ) );
                                  // add the new child
                                  node.Children.Add( child );
                              end;
                          end;
                    end;

               end;
               Break;
          end;

          // mutation goes further to one of the children
          node := node.Children[r];
          Inc(currentLevel);
     end;
end;

/// <summary>
/// Crossover operator.
/// </summary>
///
/// <param name="pair">Pair chromosome to crossover with.</param>
///
/// <remarks><para>The method performs crossover between two chromosomes – interchanging
/// randomly selected sub trees.</para></remarks>
///
procedure TGPTreeChromosome.Crossover(var pair: IChromosome);
(******************************************************************************)
var
  p          : TGPTreeChromosome;
  node,child : TGPTreeNode;
  r          : Integer;
begin
     p := TGPTreeChromosome(pair);

     // check for correct pair
     if  p <> nil  then
     begin
          // do we need to use root node for crossover ?
          if ( ( FRoot.Children = nil ) or ( Random( FMaxLevel ) = 0 ) )  then
          begin
              // give the root to the pair and use pair's part as a new root
              FRoot := p.RandomSwap( FRoot );
          end else
          begin
               node := FRoot;
               while True do
               begin
                    // choose random child
                    r     := Random( node.Gene.GetArgumentsCount );
                    child := node.Children[r];

                    // swap the random node, if it is an end node or
                    // random generator "selected" this node
                    if ( ( child.Children = nil ) or ( Random( FMaxLevel ) = 0 ) ) then
                    begin
                        // swap the node with pair's one
                        node.Children[r] := p.RandomSwap( child );
                        break;
                    end;
                    // go further by tree
                    node := child;
               end;
          end;
          // trim both of them
          Trim( FRoot, FMaxLevel );
          Trim( p.FRoot, FMaxLevel );
     end;
end;

/// <summary>
/// Crossover helper routine - selects random node of chromosomes tree and
/// swaps it with specified node.
/// </summary>
function TGPTreeChromosome.RandomSwap(source: TGPTreeNode): TGPTreeNode;
(******************************************************************************)
var
  retNode,
  Node,
  child : TGPTreeNode;
  r     : Integer;

begin
     retNode := nil;

     // swap root node ?
     if ( ( FRoot.Children = nil ) or ( Random ( maxLevel ) = 0 ) )    then
     begin
          // replace current root and return it
          retNode := FRoot;
          FRoot   := source;
     end else
     begin
          node := FRoot;

          while True do
          begin
              // choose random child
              r     := Random( node.Gene.GetArgumentsCount );
              child := node.Children[r];

              // swap the random node, if it is an end node or
              // random generator "selected" this node
              if ( ( child.Children = nil ) or ( Random( maxLevel ) = 0 ) ) then
              begin
                  // swap the node with pair's one
                  retNode          := child;
                  node.Children[r] := source;
                  break;
              end;

              // go further by tree
              node := child;
          end;
     end;
     Result := retNode;
end;

/// <summary>
/// Trim tree node, so its depth does not exceed specified level.
/// </summary>
procedure TGPTreeChromosome.Trim(node: TGPTreeNode; level: Integer);
(******************************************************************************)
var
  i : Integer;
begin
    // check if the node has children
    if ( node.Children <> nil ) then
    begin
        if ( level = 0 ) then
        begin
            // remove all children
            node.FChildren := nil;
            // and make the node of argument type
            node.Gene.Generate( gtArgument );
        end else
        begin
            // go further to children
            for i := 0 to node.Children.Count - 1 do
            begin
                Trim( node.Children[i], level - 1 );
            end;
        end;
    end;
end;

/// <summary>
/// Maximum initial level of genetic trees, [1, 25].
/// </summary>
///
/// <remarks><para>The property sets maximum possible initial depth of new
/// genetic programming tree. For example, if it is set to 1, then largest initial
/// tree may have a root and one level of children.</para>
///
/// <para>Default value is set to <b>3</b>.</para>
/// </remarks>
///
procedure TGPTreeChromosome.SetMaxInitialLevel(const Value: Integer);
(******************************************************************************)
begin
     FMaxInitialLevel := Max( 1, Min( 25, Value ) );;
end;

/// <summary>
/// Maximum level of genetic trees, [1, 50].
/// </summary>
///
/// <remarks><para>The property sets maximum possible depth of
/// genetic programming tree, which may be created with mutation and crossover operators.
/// This property guarantees that genetic programmin tree will never have
/// higher depth, than the specified value.</para>
///
/// <para>Default value is set to <b>5</b>.</para>
/// </remarks>
///
procedure TGPTreeChromosome.SetMaxLevel(const Value: Integer);
(******************************************************************************)
begin
     FMaxLevel :=  Max( 1, Min( 50, Value ) );
end;

end.
