function [Y d] = stubI_replayMessl(X, fail, fs, inFile, loadDataDir, beamformer, I)

% Load a MESSL mask and TDOA and apply it to the input the same way
% stubI_messlMc would.

if ~exist('beamformer', 'var') || isempty(beamformer), beamformer = 'bestMic'; end
if ~exist('I', 'var') || isempty(I), I = inf; end

wlen = 2*(size(X,1)-1);

% Load MESSL data structure
%...
refFile = fullfile(loadDataDir, strrep(inFile, '.CH1.wav', '.mat'));
d = load(refFile);

mask = d.data.mask(:,:,1:min(I,end));
perMicTdoa = d.data.params.perMicTdoa;
data = d.data;
switch beamformer
    case 'bestMic'
        Xp = pickChanWithBestSnr(X, mask, fail);
    case 'mvdr'
        [Xp mvdrMask mask] = maskDrivenMvdrMulti(X, mask, fail, perMicTdoa);
        data.mvdrMask2 = mvdrMask;
    case 'souden'
        [Xp mvdrMask mask] = mvdrSoudenMulti(X, mask, fail);
        data.mvdrMask = single(mvdrMask);
    otherwise
        error('Unknown beamformer: %s', beamformer)
end
data.mask2 = mask;

% Output spectrogram(s)
Y = Xp .* mask;

% refWavFile = strrep(strrep(refFile, '.mat', '.wav'), '/data/', '/wav/');
% y2 = wavread(refWavFile);
% Y2 = stft_multi(y2', wlen);
1+1;
