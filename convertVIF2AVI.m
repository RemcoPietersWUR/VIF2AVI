function [ddd,FrameNumber]=convertVIF2AVI(PathName,FileName,ConvertFrames,StartTimestamp,AOIWidth,AOIHeight)
%convertVIF2TIF read VIF file and convert frames indicated in array
%ConvertFrames to tif-files, use same location as VIF files to save the
%tif. 

%Get path and filename prefix for saving tifs
[Path,Prefix,~]=fileparts(fullfile(PathName,FileName))

%Open file
fid=fopen(fullfile(PathName,FileName));
%Seek to 65 byte (skipping header)
fseek(fid,64,'cof');
%Preallocate AVI 
AVI = zeros(AOIHeight,AOIWidth,numel(ConvertFrames),'uint8');
for frame=1:numel(ConvertFrames)
    %Read header
    timestamp = fread(fid, [1,1],'*uint64');
    %Get frame
    if ConvertFrames(frame)==1
        IM=reshape(fread(fid, [prod([AOIHeight,AOIWidth], 1)],'*uint8'),...
            AOIWidth,AOIHeight);
        IM=flipud(IM); %flip ud down
        IM=rot90(IM,3); %rotate 3x90 degrees
        ddd(frame)=timestamp-StartTimestamp;
        FrameNumber(frame)=timestamp-StartTimestamp+1;
        %make save directory tiff
        %mkdir(Path,SaveFolder)
        %imwrite(IM,[Path,filesep,SaveFolder,filesep,Prefix,'_',num2str(FrameNumber(frame)),'.tif']);
        AVI(:,:,FrameNumber(frame))=IM;
    else
        %Skip frame
        fseek(fid,AOIWidth*AOIHeight,'cof');
    end
    %Seek footer
    fseek(fid,504,'cof');
end
v = VideoWriter([Path,filesep,Prefix,'.avi'],'Grayscale AVI');
open(v)
writeVideo(v,AVI)
close(v)


