// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit SelezAlgoritmi;

interface
uses
  Windows, Messages, SysUtils, Classes,System.Math,NeuralNetDef,Cromosomi,
  System.Generics.Collections;


type
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
  ISelectionMethod = interface
    ['{071247BA-24DA-4770-8DE4-9EDFD8876CA7}']

      /// <summary>
      /// Apply selection to the specified population.
      /// </summary>
      ///
      /// <param name="chromosomes">Population, which should be filtered.</param>
      /// <param name="size">The amount of chromosomes to keep.</param>
      ///
      /// <remarks>Filters specified population according to the implemented
      /// selection algorithm.</remarks>
      ///
      procedure  ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
  end;

  /// <summary>
  /// Elite selection method.
  /// </summary>
  ///
  /// <remarks>Elite selection method selects specified amount of
  /// best chromosomes to the next generation.</remarks>
  ///
  TEliteSelection = class(TInterfacedObject,ISelectionMethod)
  public
    constructor Create;
    procedure  ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
  end;

  /// <summary>
	/// Rank selection method.
	/// </summary>
	///
	/// <remarks><para>The algorithm selects chromosomes to the new generation depending on
	/// their fitness values - the better fitness value chromosome has, the more chances
	/// it has to become member of the new generation. Each chromosome can be selected
	/// several times to the new generation.</para>
  ///
  /// <para>This algorithm is similar to <see cref="RouletteWheelSelection">Roulette Wheel
  /// Selection</see> algorithm, but the difference is in "wheel" and its sectors' size
  /// calculation method. The size of the wheel equals to <b>size * ( size + 1 ) / 2</b>,
  /// where <b>size</b> is the current size of population. The worst chromosome has its sector's
  /// size equal to 1, the next chromosome has its sector's size equal to 2, etc.</para>
  /// </remarks>
	///
  TRankSelection = class(TInterfacedObject,ISelectionMethod)
  public
    constructor Create;
    procedure  ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
  end;

  /// <summary>
	/// Roulette wheel selection method.
	/// </summary>
	///
	/// <remarks><para>The algorithm selects chromosomes to the new generation according to
	/// their fitness values - the more fitness value chromosome has, the more chances
	/// it has to become member of new generation. Each chromosome can be selected
  /// several times to the new generation.</para>
  ///
  /// <para>The "roulette's wheel" is divided into sectors, which size is proportional to
  /// the fitness values of chromosomes - the  size of the wheel is the sum of all fitness
  /// values, size of each sector equals to fitness value of chromosome.</para>
  /// </remarks>
	///
  TRouletteWheelSelection = class(TInterfacedObject,ISelectionMethod)
  public
    constructor Create;
    procedure  ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
  end;

implementation


{ TEliteSelection }

/// <summary>
/// Initializes a new instance of the <see cref="EliteSelection"/> class.
/// </summary>
constructor TEliteSelection.Create;
(******************************************************)
begin
     inherited Create;
end;

/// <summary>
/// Apply selection to the specified population.
/// </summary>
///
/// <param name="chromosomes">Population, which should be filtered.</param>
/// <param name="size">The amount of chromosomes to keep.</param>
///
/// <remarks>Filters specified population keeping only specified amount of best
/// chromosomes.</remarks>
///
procedure TEliteSelection.ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
(***************************************************************************************)
begin
     // sort chromosomes
     chromosomes.Sort;
     // remove bad chromosomes
     chromosomes.DeleteRange( size, chromosomes.Count - size );
end;

{ TRankSelection }

/// <summary>
/// Initializes a new instance of the <see cref="RankSelection"/> class.
/// </summary>
constructor TRankSelection.Create;
(******************************************************)
begin
     inherited Create;
end;

/// <summary>
/// Apply selection to the specified population.
/// </summary>
///
/// <param name="chromosomes">Population, which should be filtered.</param>
/// <param name="size">The amount of chromosomes to keep.</param>
///
/// <remarks>Filters specified population keeping only those chromosomes, which
/// won "roulette" game.</remarks>
///
procedure TRankSelection.ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
(****************************************************************************************)
var
  newPopulation   : TList<IChromosome> ;
  currentSize,i,j : Integer;
  ranges,s,
  wheelValue      : Double;
  rangeMax        : ADouble;
begin
     // new population, initially empty
     newPopulation := TList<IChromosome>.Create;
		 // size of current population
		 currentSize := chromosomes.Count;

		 // sort current population
		 chromosomes.Sort;

		 // calculate amount of ranges in the wheel
		 ranges := currentSize * ( currentSize + 1 ) / 2;

		 // create wheel ranges
		 SetLength(rangeMax,currentSize);
		 s := 0;

			for i := 0 to currentSize do
			begin
				   s           := s + ( (currentSize - i) / ranges );
				   rangeMax[i] := s;
			end;

			// select chromosomes from old population to the new population
			for  j := 0  to size - 1 do
			begin
          // get wheel value
          wheelValue := Random ;
          // find the chromosome for the wheel value
          for i := 0 to currentSize - 1 do
          begin
               if ( wheelValue <= rangeMax[i] ) then
               begin
                     // add the chromosome to the new population
                     newPopulation.Add(chromosomes[i].Clone);
                     break;
               end;
          end;
			end;
      // empty current population
			chromosomes.Clear;

			// move elements from new to current population
      chromosomes.AddRange( newPopulation );

end;

{ TRouletteWheelSelection }

/// <summary>
/// Initializes a new instance of the <see cref="RouletteWheelSelection"/> class.
/// </summary>
constructor TRouletteWheelSelection.Create;
(******************************************************)
begin
     inherited Create ;
end;

/// <summary>
/// Apply selection to the specified population.
/// </summary>
///
/// <param name="chromosomes">Population, which should be filtered.</param>
/// <param name="size">The amount of chromosomes to keep.</param>
///
/// <remarks>Filters specified population keeping only those chromosomes, which
/// won "roulette" game.</remarks>
///
procedure TRouletteWheelSelection.ApplySelection(chromosomes: TList<IChromosome>; size: Integer);
(***********************************************************************************************)
var
  newPopulation     : TList<IChromosome> ;
  currentSize,i,j,k : Integer;
  fitnessSum,s,
  wheelValue        : Double;
  rangeMax          : ADouble;
begin
     // new population, initially empty
     newPopulation := TList<IChromosome>.Create;
		 // size of current population
		 currentSize := chromosomes.Count;

			// calculate summary fitness of current population
			fitnessSum := 0;
      for i := 0 to chromosomes.Count do
          fitnessSum := fitnessSum + chromosomes[i].Fitness;

			// create wheel ranges
			SetLength(rangeMax,currentSize);
			s := 0;
			k := 0;

			for i := 0 to chromosomes.Count do
			begin
				   // cumulative normalized fitness
				   s           := s + (chromosomes[i].Fitness / fitnessSum);
				   rangeMax[k] := s;
           inc(k);
			end;

			// select chromosomes from old population to the new population
			for j := 0 to size - 1 do
      begin
				   // get wheel value
				   wheelValue := Random ;
				   // find the chromosome for the wheel value
				   for i := 0 to  currentSize- 1 do
				   begin
					     if ( wheelValue <= rangeMax[i] ) then
					     begin
						        // add the chromosome to the new population
						        newPopulation.Add( chromosomes[i].Clone );
						        break;
					     end;
				   end;
			end;
      // empty current population
			chromosomes.Clear;

			// move elements from new to current population
      chromosomes.AddRange( newPopulation );
end;

end.
