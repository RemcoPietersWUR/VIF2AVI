%Convert VIF to tiff, edited for Laura convert entire sequence

%%Load video information
%User input Excel sheet with video/sequence information
[File, Path] = uigetfile({'*.xlsx','Excel-sheet'},...
    'Video information sheet','MultiSelect', 'off');
[PathName,FileName,Ext] = fileparts(fullfile(Path,File));
VideoInfo=readtable(fullfile(PathName,[FileName,Ext]));

%Process vif2tif
%Work per sequence
Nseq=height(VideoInfo);
for row=1:numel(Nseq)
    %Preallocate timestamp array, assumption all recordings in same
    %sequences have the same frame number per recording
    timestamp=zeros(VideoInfo.Nframes(row),1,'uint64');
    %Read timestamp
    PathNameSeq=VideoInfo.PathName(row);
    FileNameSeq=VideoInfo.FileName(row);
    Nframes=VideoInfo.Nframes(row);
    AOIWidth=VideoInfo.AOIWidth(row);
    AOIHeight=VideoInfo.AOIHeight(row);
    %Get timestamp
    timestamp=VIFtimestamp(char(PathNameSeq),char(FileNameSeq),Nframes,AOIWidth,AOIHeight);
    %Indicate which frames have to converted, array of 1's and 0's. 1 = convert, 0 = no conversion
    ConvertFrames=ones(Nframes,1);
    %Convert VIF to tiff
    StartTimestamp=min(timestamp);
    convertVIF2AVI(char(PathNameSeq),char(FileNameSeq),ConvertFrames,StartTimestamp,AOIWidth,AOIHeight);
end




