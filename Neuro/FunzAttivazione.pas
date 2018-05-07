// AForge Machine Learning Library  Convert to Delphi
// AForge.NET framework
//
// 
// 
//
unit FunzAttivazione;

interface

uses
  Windows, Messages, SysUtils, Classes,Math;

type
  /// <summary>
  /// Activation function interface.
  /// </summary>
  ///
  /// <remarks>All activation functions, which are supposed to be used with
  /// neurons, which calculate their output as a function of weighted sum of
  /// their inputs, should implement this interfaces.
  /// </remarks>
  ///
  IActivationFunction = interface
     ['{FDE05BCB-0957-48B3-8132-987AA30D14E6}']

     /// <summary>
     /// Calculates function value.
     /// </summary>
     ///
     /// <param name="x">Function input value.</param>
     ///
     /// <returns>Function output value, <i>f(x)</i>.</returns>
     ///
     /// <remarks>The method calculates function value at point <paramref name="x"/>.</remarks>
     ///
     function Funzione(Value: Double):Double;

     /// <summary>
     /// Calculates function derivative.
     /// </summary>
     ///
     /// <param name="x">Function input value.</param>
     ///
     /// <returns>Function derivative, <i>f'(x)</i>.</returns>
     ///
     /// <remarks>The method calculates function derivative at point <paramref name="x"/>.</remarks>
     ///
     function Derivata(Value: Double):Double;

     /// <summary>
     /// Calculates function derivative.
     /// </summary>
     ///
     /// <param name="y">Function output value - the value, which was obtained
     /// with the help of <see cref="Function"/> method.</param>
     ///
     /// <returns>Function derivative, <i>f'(x)</i>.</returns>
     ///
     /// <remarks><para>The method calculates the same derivative value as the
     /// <see cref="Derivative"/> method, but it takes not the input <b>x</b> value
     /// itself, but the function value, which was calculated previously with
     /// the help of <see cref="Function"/> method.</para>
     ///
     /// <para><note>Some applications require as function value, as derivative value,
     /// so they can save the amount of calculations using this method to calculate derivative.</note></para>
     /// </remarks>
     ///
     function Derivata2(Value: Double):Double;
  end;

  
  ///	<summary>
  ///	  Bipolar sigmoid activation function.
  ///	</summary>
  ///	<remarks>
  ///	  <para>
  ///	    The class represents bipolar sigmoid activation function with the
  ///	    next expression:
  ///	  </para>
  ///	  <code lang="none">
  ///	                2
  ///	 f(x) = ------------------ - 1
  ///	        1 + exp(-alpha * x)
  ///
  ///	           2 * alpha * exp(-alpha * x )
  ///	 f'(x) = -------------------------------- = alpha * (1 - f(x)^2) / 2
  ///	           (1 + exp(-alpha * x))^2
  ///	 </code>
  ///	  <para>
  ///	    Output range of the function: <b>[-1, 1]</b>.
  ///	  </para>
  ///	  <para>
  ///	    Functions graph:
  ///	  </para>
  ///	  <img src="D:/Delphi Projects/IA Unit/Neuro/Images/sigmoid_bipolar.bmp" />
  ///	</remarks>
  
  TFunzioneSigmoidBipolare = class(TInterfacedObject,IActivationFunction)
  private
    // sigmoid's alpha value
    FAlpha : Double;
  public
    constructor Create(Alpha: Double = 2.0);
    function Funzione(Value: Double):Double;
    function Derivata(Value: Double):Double;
    function Derivata2(Value: Double):Double;
    /// <summary>
    /// Sigmoid's alpha value.
    /// </summary>
    ///
    /// <remarks><para>The value determines steepness of the function. Increasing value of
    /// this property changes sigmoid to look more like a threshold function. Decreasing
    /// value of this property makes sigmoid to be very smooth (slowly growing from its
    /// minimum value to its maximum value).</para>
    ///
    /// <para>Default value is set to <b>2</b>.</para>
    /// </remarks>
    ///
    property Alpha : Double read FAlpha write FAlpha;
  end;

    /// <summary>
    /// Sigmoid activation function.
    /// </summary>
    ///
    /// <remarks><para>The class represents sigmoid activation function with
    /// the next expression:
    /// <code lang="none">
    ///                1
    /// f(x) = ------------------
    ///        1 + exp(-alpha * x)
    ///
    ///           alpha * exp(-alpha * x )
    /// f'(x) = ---------------------------- = alpha * f(x) * (1 - f(x))
    ///           (1 + exp(-alpha * x))^2
    /// </code>
    /// </para>
    ///
    /// <para>Output range of the function: <b>[0, 1]</b>.</para>
    ///
    /// <para>Functions graph:</para>
    /// <img src="Images/sigmoid.bmp" width="242" height="172" />
    /// </remarks>
    ///
  TFunzioneSigmoide = class(TInterfacedObject,IActivationFunction)
  private
    // sigmoid's alpha value
    FAlpha : Double;
  public
    constructor Create(Alpha: Double = 2.0);
    function Funzione(Value: Double):Double;
    function Derivata(Value: Double):Double;
    function Derivata2(Value: Double):Double;
    /// <summary>
    /// Sigmoid's alpha value.
    /// </summary>
    ///
    /// <remarks><para>The value determines steepness of the function. Increasing value of
    /// this property changes sigmoid to look more like a threshold function. Decreasing
    /// value of this property makes sigmoid to be very smooth (slowly growing from its
    /// minimum value to its maximum value).</para>
    ///
    /// <para>Default value is set to <b>2</b>.</para>
    /// </remarks>
    ///
    property Alpha : Double read FAlpha write FAlpha;
  end;

  
  ///	<summary>
  ///	  Threshold activation function.
  ///	</summary>
  ///	<remarks>
  ///	  <para>
  ///	    The class represents threshold activation function with the next
  ///	    expression:
  ///	  </para>
  ///	  <code lang="none">
  ///	 f(x) = 1, if x &gt;= 0, otherwise 0
  ///	 </code>
  ///	  <para>
  ///	    Output range of the function: <b>[0, 1]</b>.
  ///	  </para>
  ///	  <para>
  ///	    Functions graph:
  ///	  </para>
  ///	  <img src="D:/Delphi Projects/IA Unit/Neuro/Images/threshold.bmp" />
  ///	</remarks>
 
  TFunzioneThreshold = class(TInterfacedObject,IActivationFunction)
  public
    constructor Create;
    function Funzione(Value: Double):Double;
    // derivata 1 e 2 non supportata
    function Derivata(Value: Double):Double;
    function Derivata2(Value: Double):Double;
  end;


implementation

{ TFunzioneSigmoidBipolare }

/// <summary>
/// Initializes a new instance of the <see cref="BipolarSigmoidFunction"/> class.
/// </summary>
///
/// <param name="alpha">Sigmoid's alpha value.</param>
///
constructor TFunzioneSigmoidBipolare.Create(Alpha: Double = 2);
begin
    FAlpha := Alpha;
end;

/// <summary>
/// Calculates function value.
/// </summary>
///
/// <param name="x">Function input value.</param>
///
/// <returns>Function output value, <i>f(x)</i>.</returns>
///
/// <remarks>The method calculates function value at point <paramref name="x"/>.</remarks>
///
function TFunzioneSigmoidBipolare.Funzione(Value: Double):Double;
begin
    Result := ( ( 2 / ( 1 + Exp( -FAlpha * Value ) ) ) - 1 );
end;

/// <summary>
/// Calculates function derivative.
/// </summary>
///
/// <param name="x">Function input value.</param>
///
/// <returns>Function derivative, <i>f'(x)</i>.</returns>
///
/// <remarks>The method calculates function derivative at point <paramref name="x"/>.</remarks>
///
function TFunzioneSigmoidBipolare.Derivata(Value: Double): Double;
var
  y : Double;
begin
    y      := Funzione(Value);
    Result := ( FAlpha * ( 1 - y * y ) / 2 );
end;

// <summary>
/// Calculates function derivative.
/// </summary>
///
/// <param name="y">Function output value - the value, which was obtained
/// with the help of <see cref="Function"/> method.</param>
///
/// <returns>Function derivative, <i>f'(x)</i>.</returns>
///
/// <remarks><para>The method calculates the same derivative value as the
/// <see cref="Derivative"/> method, but it takes not the input <b>x</b> value
/// itself, but the function value, which was calculated previously with
/// the help of <see cref="Function"/> method.</para>
///
/// <para><note>Some applications require as function value, as derivative value,
/// so they can save the amount of calculations using this method to calculate derivative.</note></para>
/// </remarks>
///
function TFunzioneSigmoidBipolare.Derivata2(Value: Double): Double;
begin
     Result :=  ( FAlpha * ( 1 - Value * Value ) / 2 );
end;

{ TFunzioneSigmoide }

/// <summary>
/// Initializes a new instance of the <see cref="SigmoidFunction"/> class.
/// </summary>
///
/// <param name="alpha">Sigmoid's alpha value.</param>
///
constructor TFunzioneSigmoide.Create(Alpha: Double = 2);
begin
      FAlpha := Alpha;
end;

/// <summary>
/// Calculates function value.
/// </summary>
///
/// <param name="x">Function input value.</param>
///
/// <returns>Function output value, <i>f(x)</i>.</returns>
///
/// <remarks>The method calculates function value at point <paramref name="x"/>.</remarks>
///
function TFunzioneSigmoide.Funzione(Value: Double): Double;
begin
     Result := ( 1 / ( 1 + Exp( -Falpha * Value ) ) );
end;

/// <summary>
/// Calculates function derivative.
/// </summary>
///
/// <param name="x">Function input value.</param>
///
/// <returns>Function derivative, <i>f'(x)</i>.</returns>
///
/// <remarks>The method calculates function derivative at point <paramref name="x"/>.</remarks>
///
function TFunzioneSigmoide.Derivata(Value: Double): Double;
var
  y : Double;
begin
    y      := Funzione(Value);
    Result := ( FAlpha * y * ( 1 - y ) );
end;

/// <summary>
/// Calculates function derivative.
/// </summary>
///
/// <param name="y">Function output value - the value, which was obtained
/// with the help of <see cref="Function"/> method.</param>
///
/// <returns>Function derivative, <i>f'(x)</i>.</returns>
///
/// <remarks><para>The method calculates the same derivative value as the
/// <see cref="Derivative"/> method, but it takes not the input <b>x</b> value
/// itself, but the function value, which was calculated previously with
/// the help of <see cref="Function"/> method.</para>
///
/// <para><note>Some applications require as function value, as derivative value,
/// so they can save the amount of calculations using this method to calculate derivative.</note></para>
/// </remarks>
///
function TFunzioneSigmoide.Derivata2(Value: Double): Double;
begin
     Result := ( FAlpha * Value * ( 1 - Value ) );
end;

{ TFunzioneThreshold }

/// <summary>
/// Initializes a new instance of the <see cref="ThresholdFunction"/> class.
/// </summary>
constructor TFunzioneThreshold.Create;
begin

end;

/// Calculates function value.
/// </summary>
///
/// <param name="x">Function input value.</param>
///
/// <returns>Function output value, <i>f(x)</i>.</returns>
///
/// <remarks>The method calculates function value at point <paramref name="x"/>.</remarks>
///
function TFunzioneThreshold.Funzione(Value: Double): Double;
begin
    if Value >= 0 then
       Result := 1
    else
       Result := 0;
end;

/// <summary>
/// Calculates function derivative (not supported).
/// </summary>
///
/// <param name="x">Input value.</param>
///
/// <returns>Always returns 0.</returns>
///
/// <remarks><para><note>The method is not supported, because it is not possible to
/// calculate derivative of the function.</note></para></remarks>
///
function TFunzioneThreshold.Derivata(Value: Double): Double;
begin
     Result :=0;
end;

/// <summary>
/// Calculates function derivative (not supported).
/// </summary>
///
/// <param name="y">Input value.</param>
///
/// <returns>Always returns 0.</returns>
///
/// <remarks><para><note>The method is not supported, because it is not possible to
/// calculate derivative of the function.</note></para></remarks>
///
function TFunzioneThreshold.Derivata2(Value: Double): Double;
begin
     Result := 0;
end;

end.
