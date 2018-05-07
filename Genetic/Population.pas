// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit Population;

interface
uses
  Windows,
  System.Math,
  System.SysUtils,
  System.Generics.Collections,
  Cromosomi,SelezAlgoritmi;

type

    /// <summary>
    /// Population of chromosomes.
    /// </summary>
    ///
    /// <remarks><para>The class represents population - collection of individuals (chromosomes)
    /// and provides functionality for common population's life cycle - population growing
    /// with help of genetic operators and selection of chromosomes to new generation
    /// with help of selection algorithm. The class may work with any type of chromosomes
    /// implementing <see cref="IChromosome"/> interface, use any type of fitness functions
    /// implementing <see cref="IFitnessFunction"/> interface and use any type of selection
    /// algorithms implementing <see cref="ISelectionMethod"/> interface.</para>
    /// </remarks>
    ///
    TPopulation = class
    private
      FFitnessFunction : IFitnessFunction;
      FSelectionMethod : ISelectionMethod ;
      FPopulation      : TList<IChromosome>  ;
      FSize            : Integer;
      FRndSelPortion   : Double;
      FAutoShuffling   : Boolean;
      // population parameters
      FCrossoverRate   : Double;
      FMutationRate    : Double;
      //
      FFitnessMax      : Double;
      FFitnessSum      : Double ;
      FFitnessAvg      : Double ;
      FBestChromosome  : IChromosome;
      procedure   FindBestChromosome;
      function    GetPopulation(Index: integer): IChromosome;
      procedure   SetCrossoverRate(const Value: Double);
      procedure   SetFitnessFunction(const Value: IFitnessFunction);
      procedure   SetMutationRate(const Value: Double);
      procedure   SetRndSelPortion(const Value: Double);
    public
      constructor Create(size : Integer; ancestor : IChromosome; fitnessFunction : IFitnessFunction;selectionMethod: ISelectionMethod);
      procedure   Regenerate;
      procedure   Crossover;
      procedure   Mutate;
      procedure   Selection;
      procedure   RunEpoch;
      procedure   Shuffle;
      procedure   AddChromosome(chromosome: IChromosome);
      procedure   Migrate(anotherPopulation : TPopulation;numberOfMigrants: Integer; migrantsSelector: ISelectionMethod );
      procedure   Resize(newPopulationSize: Integer ); overload;
      procedure   Resize(newPopulationSize: Integer; membersSelector: ISelectionMethod); overload;
      property CrossoverRate   : Double           read FCrossoverRate   write SetCrossoverRate;
      property MutationRate    : Double           read FMutationRate    write SetMutationRate;
      property RndSelPortion   : Double           read FRndSelPortion   write SetRndSelPortion;
      property AutoShuffling   : Boolean          read FAutoShuffling   write FAutoShuffling;
      property SelectionMethod : ISelectionMethod read FSelectionMethod write FSelectionMethod ;
      property FitnessFunction : IFitnessFunction read FFitnessFunction write SetFitnessFunction;
      property FitnessMax      : Double           read FFitnessMax;
      property FitnessSum      : Double           read FFitnessSum;
      property FitnessAvg      : Double           read FFitnessAvg;
      property BestChromosome  : IChromosome      read FBestChromosome;
      property Size            : Integer          read FSize;
      property PopulationIndex[Index: integer]  : IChromosome read GetPopulation;
      property Population : TList<IChromosome> read FPopulation;
    end;

implementation

{ TPopulation }

/// <summary>
/// Crossover rate, [0.1, 1].
/// </summary>
///
/// <remarks><para>The value determines the amount of chromosomes which participate
/// in crossover.</para>
///
/// <para>Default value is set to <b>0.75</b>.</para>
/// </remarks>
///
procedure TPopulation.SetCrossoverRate(const Value: Double);
(***********************************************************)
begin
     FCrossoverRate := Max( 0.1, Min( 1.0, Value ) )
end;

/// <summary>
/// Mutation rate, [0.1, 1].
/// </summary>
///
/// <remarks><para>The value determines the amount of chromosomes which participate
/// in mutation.</para>
///
/// <para>Defaul value is set to <b>0.1</b>.</para></remarks>
///
procedure TPopulation.SetMutationRate(const Value: Double);
(***********************************************************)
begin
     FMutationRate := Max( 0.1, Min( 1.0, Value ) )
end;

/// <summary>
/// Random selection portion, [0, 0.9].
/// </summary>
///
/// <remarks><para>The value determines the amount of chromosomes which will be
/// randomly generated for the new population. The property controls the amount
/// of chromosomes, which are selected to a new population using
/// <see cref="SelectionMethod">selection operator</see>, and amount of random
/// chromosomes added to the new population.</para>
///
/// <para>Default value is set to <b>0</b>.</para></remarks>
///
procedure TPopulation.SetRndSelPortion(const Value: Double);
(***********************************************************)
begin
     FRndSelPortion := Max( 0, Min( 0.9, value ) );
end;

/// <summary>
/// Fitness function to apply to the population.
/// </summary>
///
/// <remarks><para>The property sets fitness function, which is used to evaluate
/// usefulness of population's chromosomes. Setting new fitness function causes recalculation
/// of fitness values for all population's members and new best member will be found.</para>
/// </remarks>
///
procedure TPopulation.SetFitnessFunction(const Value: IFitnessFunction);
(***********************************************************)
var
  i : Integer;
begin
     FFitnessFunction := Value;
     for i := 0 to FPopulation.Count - 1 do
        FPopulation[i].Evaluate(FFitnessFunction);

     FindBestChromosome;
end;

function TPopulation.GetPopulation(Index: integer): IChromosome;
(***********************************************************)
begin
     try
       Result := FPopulation[Index];
     except
          on E: ERangeError do
                raise E.CreateFmt('Indice non compreso nell''Intervallo', [Index])
     end;
end;

/// <summary>
/// Initializes a new instance of the <see cref="Population"/> class.
/// </summary>
///
/// <param name="size">Initial size of population.</param>
/// <param name="ancestor">Ancestor chromosome to use for population creatioin.</param>
/// <param name="fitnessFunction">Fitness function to use for calculating
/// chromosome's fitness values.</param>
/// <param name="selectionMethod">Selection algorithm to use for selection
/// chromosome's to new generation.</param>
///
/// <remarks>Creates new population of specified size. The specified ancestor
/// becomes first member of the population and is used to create other members
/// with same parameters, which were used for ancestor's creation.</remarks>
///
/// <exception cref="ArgumentException">Too small population's size was specified. The
/// exception is thrown in the case if <paramref name="size"/> is smaller than 2.</exception>
///
constructor TPopulation.Create(size: Integer; ancestor: IChromosome; fitnessFunction: IFitnessFunction; selectionMethod: ISelectionMethod);
(****************************************************************************************************************************************)
var
  i : Integer;
  c : IChromosome;
begin
    if  size < 2 then raise Exception.Create('Too small population''s size was specified.' );

    FFitnessFunction := fitnessFunction;
    FSelectionMethod := selectionMethod;
    FSize            := size;
    FPopulation      := TList<IChromosome>.Create;

   FRndSelPortion    := 0.0;
   FAutoShuffling    := false;

   // population parameters
   FCrossoverRate    := 0.75;
   FMutationRate	   := 0.10;

   FfitnessMax       := 0;
   FfitnessSum       := 0;
   FfitnessAvg       := 0;

    // add ancestor to the population
    ancestor.Evaluate( fitnessFunction );
    FPopulation.Add( ancestor.Clone );
    // add more chromosomes to the population
    for i := 1 to size - 1 do
    begin
        // create new chromosome
        c := ancestor.CreateNew;
        // calculate it's fitness
        c.Evaluate( fitnessFunction );
        // add it to population
        FPopulation.Add( c );
    end;
end;

/// <summary>
/// Regenerate population.
/// </summary>
///
/// <remarks>The method regenerates population filling it with random chromosomes.</remarks>
///
procedure TPopulation.Regenerate;
(***********************************************************)
var
   ancestor,c : IChromosome;
   i          : Integer;
begin
     ancestor := FPopulation[0];

     // clear population
     FPopulation.Clear;
     // add chromosomes to the population
     for i := 0 to FSize - 1 do
     begin
          // create new chromosome
          c := ancestor.CreateNew;
          // calculate it's fitness
          c.Evaluate( FFitnessFunction );
          // add it to population
          FPopulation.Add( c );
     end;
end;

/// <summary>
/// Do crossover in the population.
/// </summary>
///
/// <remarks>The method walks through the population and performs crossover operator
/// taking each two chromosomes in the order of their presence in the population.
/// The total amount of paired chromosomes is determined by
/// <see cref="CrossoverRate">crossover rate</see>.</remarks>
///
procedure TPopulation.Crossover;
(************************************)
var
  c1,c2 : IChromosome;
  i     : Integer;
begin
      // crossover
      i := 1;
      repeat
           // generate next random number and check if we need to do crossover
          if ( Random <= FCrossoverRate ) then
          begin
              // clone both ancestors
              c1 := FPopulation[i - 1].Clone;
              c2 := FPopulation[i].Clone;

              // do crossover
              c1.Crossover( c2 );

              // calculate fitness of these two offsprings
              c1.Evaluate( FFitnessFunction );
              c2.Evaluate( FFitnessFunction );

              // add two new offsprings to the population
              FPopulation.Add( c1 );
              FPopulation.Add( c2 );
          end;
          inc(i,2);
      until  i > FSize;
end;

/// <summary>
/// Do mutation in the population.
/// </summary>
///
/// <remarks>The method walks through the population and performs mutation operator
/// taking each chromosome one by one. The total amount of mutated chromosomes is
/// determined by <see cref="MutationRate">mutation rate</see>.</remarks>
///
procedure TPopulation.Mutate;
(***********************************************************)
var
  i: Integer;
  c: IChromosome;
begin
      // mutate
      for i := 0 to FSize - 1 do
      begin
          // generate next random number and check if we need to do mutation
          if ( Random <= FMutationRate ) then
          begin
              // clone the chromosome
              c := FPopulation[i].Clone;
              // mutate it
              c.Mutate;
              // calculate fitness of the mutant
              c.Evaluate( FFitnessFunction );
              // add mutant to the population
              FPopulation.Add( c );
          end;
      end;
end;

/// <summary>
/// Do selection.
/// </summary>
///
/// <remarks>The method applies selection operator to the current population. Using
/// specified selection algorithm it selects members to the new generation from current
/// generates and adds certain amount of random members, if is required
/// (see <see cref="RandomSelectionPortion"/>).</remarks>
///
procedure TPopulation.Selection;
(***********************************************************)
var
   randomAmount,i : Integer;
   ancestor,c     : IChromosome;
begin
      // amount of random chromosomes in the new population
      randomAmount := Trunc(FRndSelPortion * FSize) ;

      // do selection
      FSelectionMethod.ApplySelection( FPopulation, FSize - randomAmount );

      // add random chromosomes
      if ( randomAmount > 0 ) then
      begin
            ancestor := FPopulation[0];
            for i := 0 to randomAmount do
            begin
                // create new chromosome
                c := ancestor.CreateNew;
                // calculate it's fitness
                c.Evaluate( FFitnessFunction );
                // add it to population
                FPopulation.Add( c );
            end;
      end;
      FindBestChromosome;
end;

/// <summary>
/// Run one epoch of the population.
/// </summary>
///
/// <remarks>The method runs one epoch of the population, doing crossover, mutation
/// and selection by calling <see cref="Crossover"/>, <see cref="Mutate"/> and
/// <see cref="Selection"/>.</remarks>
///
procedure TPopulation.RunEpoch;
(***********************************************************)
begin
     Crossover;
     Mutate;
     Selection;

     if FAutoShuffling then  Shuffle;
end;

/// <summary>
/// Shuffle randomly current population.
/// </summary>
///
/// <remarks><para>Population shuffling may be useful in cases when selection
/// operator results in not random order of chromosomes (for example, after elite
/// selection population may be ordered in ascending/descending order).</para></remarks>
///
procedure TPopulation.Shuffle;
(***********************************************************)
var
  nSize,i : Integer;
  tempPopulation : TList<IChromosome>;
begin
     // current population size
     nSize := FPopulation.Count;
     // create temporary copy of the population
     tempPopulation := FPopulation;
     // clear current population and refill it randomly
     FPopulation.Clear;
     while ( nSize > 0 ) do
     begin
          i := Random( nSize );
          FPopulation.Add( tempPopulation[i] );
          tempPopulation.Delete( i );
          Dec(nSize);
     end;
end;

/// <summary>
/// Add chromosome to the population.
/// </summary>
///
/// <param name="chromosome">Chromosome to add to the population.</param>
///
/// <remarks><para>The method adds specified chromosome to the current population.
/// Manual adding of chromosome maybe useful, when it is required to add some initialized
/// chromosomes instead of random.</para>
///
/// <para><note>Adding chromosome manually should be done very carefully, since it
/// may break the population. The manually added chromosome must have the same type
/// and initialization parameters as the ancestor passed to constructor.</note></para>
/// </remarks>
///
procedure TPopulation.AddChromosome(chromosome: IChromosome);
(***********************************************************)
begin
      chromosome.Evaluate( fitnessFunction );
      FPopulation.Add( chromosome );
end;

/// <summary>
/// Perform migration between two populations.
/// </summary>
///
/// <param name="anotherPopulation">Population to do migration with.</param>
/// <param name="numberOfMigrants">Number of chromosomes from each population to migrate.</param>
/// <param name="migrantsSelector">Selection algorithm used to select chromosomes to migrate.</param>
///
/// <remarks><para>The method performs migration between two populations - current and the
/// <paramref name="anotherPopulation">specified one</paramref>. During migration
/// <paramref name="numberOfMigrants">specified number</paramref> of chromosomes is choosen from
/// each population using <paramref name="migrantsSelector">specified selection algorithms</paramref>
/// and put into another population replacing worst members there.</para></remarks>
///
procedure TPopulation.Migrate(anotherPopulation: TPopulation; numberOfMigrants: Integer; migrantsSelector: ISelectionMethod);
(****************************************************************************************************************************)
var
  currentSize,i,
  anotherSize   : Integer;
  currentCopy,
  anotherCopy  : TList<IChromosome>;
begin
      currentSize := FSize;
      anotherSize := anotherPopulation.Size;

      // create copy of current population
      currentCopy := TList<IChromosome>.Create;

      for i := 0 to currentSize - 1 do
      begin
          currentCopy.Add( FPopulation[i].Clone );
      end;

      // create copy of another population
      anotherCopy  := TList<IChromosome>.Create;

      for i := 0 to  anotherSize - 1 do
      begin
          anotherCopy.Add( anotherPopulation.population[i].Clone);
      end;

      // apply selection to both populations' copies - select members to migrate
      migrantsSelector.ApplySelection( currentCopy, numberOfMigrants );
      migrantsSelector.ApplySelection( anotherCopy, numberOfMigrants );

      // sort original populations, so the best chromosomes are in the beginning
      FPopulation.Sort;
      anotherPopulation.population.Sort;

      // remove worst chromosomes from both populations to free space for new members
      FPopulation.DeleteRange( currentSize - numberOfMigrants, numberOfMigrants );
      anotherPopulation.population.DeleteRange( anotherSize - numberOfMigrants, numberOfMigrants );

      // put migrants to corresponding populations
      population.AddRange( anotherCopy );
      anotherPopulation.population.AddRange( currentCopy );

      // find best chromosomes in each population
      FindBestChromosome;
      anotherPopulation.FindBestChromosome;
end;

/// <summary>
/// Resize population to the new specified size.
/// </summary>
///
/// <param name="newPopulationSize">New size of population.</param>
///
/// <remarks><para>The method does resizing of population. In the case if population
/// should grow, it just adds missing number of random members. In the case if
/// population should get smaller, the <see cref="SelectionMethod">population's
/// selection method</see> is used to reduce the population.</para></remarks>
///
/// <exception cref="ArgumentException">Too small population's size was specified. The
/// exception is thrown in the case if <paramref name="newPopulationSize"/> is smaller than 2.</exception>
///
procedure TPopulation.Resize(newPopulationSize: Integer);
(***********************************************************)
begin
     Resize( newPopulationSize, FSelectionMethod );
end;

/// <summary>
/// Resize population to the new specified size.
/// </summary>
///
/// <param name="newPopulationSize">New size of population.</param>
/// <param name="membersSelector">Selection algorithm to use in the case
/// if population should get smaller.</param>
///
/// <remarks><para>The method does resizing of population. In the case if population
/// should grow, it just adds missing number of random members. In the case if
/// population should get smaller, the specified selection method is used to
/// reduce the population.</para></remarks>
///
/// <exception cref="ArgumentException">Too small population's size was specified. The
/// exception is thrown in the case if <paramref name="newPopulationSize"/> is smaller than 2.</exception>
///
procedure TPopulation.Resize(newPopulationSize: Integer; membersSelector: ISelectionMethod);
(*******************************************************************************************)
var
  toAdd,i : Integer;
  c       : IChromosome;
begin
      if newPopulationSize < 2 then raise Exception.Create('Too small new population''s size was specified.' );

      if  newPopulationSize > FSize then
      begin
          // population is growing, so add new rundom members

          // Note: we use population.Count here instead of "size" because
          // population may be bigger already after crossover/mutation. So
          // we just keep those members instead of adding random member.
          toAdd := newPopulationSize - FPopulation.Count;

          for i := 0 to toAdd do
          begin
              // create new chromosome
              c := FPopulation[0].CreateNew;
              // calculate it's fitness
              c.Evaluate( FFitnessFunction );
              // add it to population
              FPopulation.Add( c );
          end;
      end else
      begin
          // do selection
          membersSelector.ApplySelection( FPopulation, newPopulationSize );
      end;

      FSize := newPopulationSize;
end;

// Find best chromosome in the population so far
procedure TPopulation.FindBestChromosome;
(***********************************************************)
var
  i        : Integer;
  nfitness : Double;
begin
      FBestChromosome := FPopulation[0];
      FFitnessMax     := FBestChromosome.Fitness;
      FFitnessSum     := FFitnessMax;

      for i := 1 to FSize - 1 do
      begin
           nfitness := FPopulation[i].Fitness;

           // accumulate summary value
           FFitnessSum := FFitnessSum + nfitness;

           // check for max
           if nfitness > FFitnessMax then
           begin
                FFitnessMax     := nfitness;
                FBestChromosome := FPopulation[i];
           end;
      end;
      FFitnessAvg := FFitnessSum / FSize;
end;

end.
