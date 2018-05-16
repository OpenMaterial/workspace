function [fitresult, gof] = createFit_COND(x0J, x0W, x0S)

[xData, yData, zData] = prepareSurfaceData( x0J, x0W, x0S );

% Set up fittype and options.
ft = fittype( 'poly11' );

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );

% Plot fit with data.
h = plot( fitresult, [xData, yData], zData );
legend( h, 'Fitting surface', 'Data', 'Location', 'NorthEast' );

% Label axes
xlabel( 'LNG' );
ylabel( 'LAT' );
zlabel( 'COND' );
hold on
