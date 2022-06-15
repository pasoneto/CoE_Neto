addpath('/Users/pdealcan/Documents/github/matlabTools/MocapToolbox/mocaptoolbox')
addpath('/Users/pdealcan/Documents/github/matlabTools/MIRtoolbox/MIRToolbox')
addpath('/Users/pdealcan/Documents/github/matlabTools/MIRtoolbox/AuditoryToolbox')

path_dance = "/project/data/binary.tsv";

load mcdemodata

dance1 = mcfillgaps(dance1)
S = mcgetmarker(dance2, 2, 3) %get one marker






%MIR data
path_sounds = '/Users/pdealcan/Documents/github/doc_suomi/text/CoE/project/';
mirwaitbar(0)
song = 'sound_new.mp3'

A = miraudio(strcat(path_sounds, song));
A = mirframe(A);

mirspectrum(A)
mirpulseclarity(A)
mirbeatspectrum(A)
mirmetroid(A)

b = ["track1", "track2", "track3", "track4", "track5"]
c = ["tracks", "tempo", "loudness", "novelty", "arousal", "valence"]

output_features = table([tempos; loudness; novelty; valence; arousal])
writetable(output_features, '/Users/pdealcan/Documents/github/doc_suomi/text/CoE/project/mir_data_ambiguous.csv')
