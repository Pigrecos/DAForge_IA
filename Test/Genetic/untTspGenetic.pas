{*******************************************************}
{                                                       }
{       Soluzione problema Commesso Viaggiatore         }
{       Applicazione Agoritmi Genetici alla             }
{       Risoluzione del problema del commesso viag      }
{       Copyright (C) 2013 Max                          }
{                                                       }
{*******************************************************}

unit untTspGenetic;

interface
uses System.Math, System.SysUtils,
Cromosomi,
NeuralNetDef;

type
 /// <summary>
	/// Fitness function for TSP task (Travaling Salasman Problem)
	/// </summary>
	TTSPFitnessFunction = class(TInterfacedObject,IFitnessFunction)
  private
     // map
		 FMap : AADouble;
  public
      constructor Create(map: AADouble);
      Function    Evaluate(chromosome : IChromosome ): Double;
      function    Translate( chromosome : IChromosome ): string;
      function    PathLength(chromosome: IChromosome):Double ;
  end;

  /// <summary>
	/// The chromosome is to solve TSP task (Travailing Salesman Problem).
	/// </summary>
  TTSPChromosome  = class(TPermutationChromosome)
    private
      FMap : AADouble;
      procedure CreateChildUsingCrossover( parent1, parent2, child : AWord);
    public
      constructor Create(map : AADouble); overload;
      constructor Create(source : TTSPChromosome); overload;
      function    CreateNew: IChromosome; override;
      function    Clone:IChromosome; override;
      procedure   Crossover(var pair: IChromosome); override;
  end;

implementation

{ TTSPFitnessFunction }

// Constructor
constructor TTSPFitnessFunction.Create(map: AADouble);
(*******************************************************************************)
begin
     FMap := map;
end;

/// <summary>
/// Evaluate chromosome - calculates its fitness value
/// </summary>
function TTSPFitnessFunction.Evaluate(chromosome: IChromosome): Double;
(*******************************************************************************)
begin
     Result :=  1 / ( PathLength( chromosome ) + 1 );
end;

/// <summary>
/// Translate genotype to phenotype
/// </summary>
function TTSPFitnessFunction.Translate(chromosome: IChromosome): string;
(*******************************************************************************)
begin
      Result :=  chromosome.ToString;
end;

/// <summary>
/// Calculate path length represented by the specified chromosome
/// </summary>
function TTSPFitnessFunction.PathLength(chromosome: IChromosome):Double;
(*******************************************************************************)
var
  path : AWord;
  prev,curr,i : Integer;
  dx,dy,pathLength : Double;
begin
     // salesman path
			path := TPermutationChromosome(chromosome).Value;

			// check path size
			if  Length( path ) <> Length(FMap) then
			raise Exception.Create( 'Invalid path specified - not all cities are visited' );

			// path length
			prev := path[0];
			curr := path[Length(path) - 1];

			// calculate distance between the last and the first city
			dx         := FMap[curr, 0] - FMap[prev, 0];
			dy         := FMap[curr, 1] - FMap[prev, 1];
			pathLength := Sqrt( dx * dx + dy * dy );

			// calculate the path length from the first city to the last
			for i := 1  to Length(path) - 1 do
			begin
          // get current city
          curr := path[i];

          // calculate distance
          dx         := FMap[curr, 0] - FMap[prev, 0];
          dy         := FMap[curr, 1] - FMap[prev, 1];
          pathLength := pathLength + Sqrt( dx * dx + dy * dy );

          // put current city as previous
          prev := curr;
			end;
      Result := pathLength;
end;

{ TTSPChromosome }

/// <summary>
/// Constructor
/// </summary>
constructor TTSPChromosome.Create(map: AADouble);
(*******************************************************************************)
begin
     inherited Create(Length(map));
     FMap := map;
end;

/// <summary>
/// Copy Constructor
/// </summary>
constructor TTSPChromosome.Create(source: TTSPChromosome);
(*******************************************************************************)
begin
     inherited Create(source);
     FMap := source.FMap;
end;

/// <summary>
/// Create new random chromosome (factory method)
/// </summary>
function TTSPChromosome.CreateNew: IChromosome;
(*******************************************************************************)
begin
     Result := TTSPChromosome.Create( FMap );
end;

/// <summary>
/// Clone the chromosome
/// </summary>
function TTSPChromosome.Clone: IChromosome;
(*******************************************************************************)
begin
     Result := TTSPChromosome.Create( Self );
end;

/// <summary>
/// Crossover operator
/// </summary>
procedure TTSPChromosome.Crossover(var pair: IChromosome);
(*******************************************************************************)
var
 p             :  TTSPChromosome;
 child1,child2 : AWord;
begin
    p := TTSPChromosome(pair);

			// check for correct pair
			if ( ( p <> nil ) and ( p.nLength =  FLength ) ) then
			begin
				   SetLength(child1,FLength);
				   SetLength(child2,FLength);

				   // create two children
				   CreateChildUsingCrossover( FValue, p.Value, child1 );
				   CreateChildUsingCrossover( p.Value, FValue, child2 );

				   // replace parents with children
				   FValue	 := child1;
				   p.Value := child2;
			end;

end;

// Produce new child applying crossover to two parents
procedure TTSPChromosome.CreateChildUsingCrossover(parent1, parent2, child: AWord);
(*******************************************************************************)
var
  geneIsBusy        : array of Boolean;  // temporary array to specify if certain gene already present in the child
  prev, next1, next2: Word;              // previous gene in the child and two next candidates
  valid1, valid2    : Boolean;           // candidates validness - candidate is valid, if it is not yet in the child
  j, k ,i,r         : Integer;
  dx1,dx2,dy1,dy2   : Double;
begin
      SetLength( geneIsBusy, FLength);
      j := FLength - 1;
      k := j;
      // first gene of the child is taken from the second parent
      child[0]         := parent2[0];
			prev             := child[0] ;
			geneIsBusy[prev] := true;

			// resolve all other genes of the child
			for i := 1 to FLength - 1 do
			begin
           // find the next gene after PREV in both parents
				   // 1
           for j := 0 to k  do
           begin
                if  parent1[j] = prev then break;
           end;

           if   j = k then next1 := parent1[0]
           else            next1 := parent1[j + 1];
           // 2
           for j := 0 to k  do
           begin
                if  parent2[j] = prev then break;
           end;

           if   j = k then next2 := parent2[0]
           else            next2 := parent2[j + 1];

           // check candidate genes for validness
				   valid1 := not geneIsBusy[next1];
				   valid2 := not geneIsBusy[next2];
           // select gene
				   if  valid1 and  valid2  then
				   begin
                // both candidates are valid
					      // select one closest city
					      dx1  := FMap[next1, 0] - FMap[prev, 0];
					      dy1  := FMap[next1, 1] - FMap[prev, 1];
					      dx2  := FMap[next2, 0] - FMap[prev, 0];
					      dy2  := FMap[next2, 1] - FMap[prev, 1];
                if Sqrt( dx1 * dx1 + dy1 * dy1 ) < Sqrt( dx2 * dx2 + dy2 * dy2 ) then  prev :=  next1
                else                                                                   prev :=  next2;
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

end.
