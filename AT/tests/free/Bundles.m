sigma = 0.5;
z = 0:0.01:1;

Amp = exp( -0.5 * (  z    ./ sigma ).^2 ) / ( 2 * sigma ) + ...
      exp( -0.5 * ( (z-1) ./ sigma ).^2 ) / ( 2 * sigma ) + ...
      exp( -0.5 * ( (z+1) ./ sigma ).^2 ) / ( 2 * sigma ) + ...
      exp( -0.5 * ( (z-2) ./ sigma ).^2 ) / ( 2 * sigma ) + ...
      exp( -0.5 * ( (z+2) ./ sigma ).^2 ) / ( 2 * sigma );
  
  figure; plot( z, Amp )
  figure; plot( z, 20 * log10( Amp ) )
  mean( Amp )
  