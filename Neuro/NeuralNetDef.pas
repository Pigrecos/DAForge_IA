unit NeuralNetDef;

interface

type
   AWord     = array of word;
   ADouble   = array of Double ;
   AADouble  = array of ADouble;
   
   Modes = (
     ///	<summary>
     ///	  Search for function's maximum value
     ///	</summary>
     omMaximization,

     ///	<summary>
     ///	  Search for function's minimum value.
     ///	</summary>
     omMinimization
   );
   
   GPGeneType = (
     ///	<summary>
     ///	  Function gene - represents function to be executed.
     ///	</summary>
     gtFunction,

     ///	<summary>
     ///	  Argument gene - represents argument of function.
     ///	</summary>
     gtArgument
   );

   TRange  = record
     nLength: Double;   // Length of the range (deffirence between maximum and minimum values).
     Max    : Double;   // Maximum value of the range.
     Min    : Double ;  // Minimum value of the range.
     procedure Range(min, max: Double );   //Initializes a new instance of the AForge.Range structure.
   end;

  TOnEpochPassed = reference to procedure(Epoca: int64);

implementation

{ TRange }

procedure TRange.Range(min, max: Double);
begin
     self.Min := min;
     self.Max := max;
     Self.nLength := max - min;
end;

end.
