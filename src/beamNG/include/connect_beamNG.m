
% Python has to be connected to tzhe Windows path
pe = pyenv('Version','3.12');

beamng = py.beamngpy.BeamNGpy('localhost', int32(25252), ...
    pyargs('home', 'C:\Programme\BeamNG.tech.v0.36.4.0'));

beamng.open(py.list({string(missing),'Value'}), ...
    '-gfx', 'dx11', listen_ip='*')