function varargout = DataAnalysis(varargin)
% DATAANALYSIS MATLAB code for DataAnalysis.fig
%      DATAANALYSIS, by itself, creates a new DATAANALYSIS or raises the existing
%      singleton*.
%
%      H = DATAANALYSIS returns the handle to a new DATAANALYSIS or the handle to
%      the existing singleton*.
%
%      DATAANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAANALYSIS.M with the given input arguments.
%
%      DATAANALYSIS('Property','Value',...) creates a new DATAANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataAnalysis

% Last Modified by GUIDE v2.5 29-Apr-2013 13:38:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DataAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @DataAnalysis_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DataAnalysis is made visible.
function DataAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataAnalysis (see VARARGIN)

% Choose default command line output for DataAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% SELECT DATA FILES
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fnames pathname] = uigetfile({'*.mat';'*.smr';'*.smrx'},'Choose file(s) to analyze:','multiselect','on');
handles.FNAMES=fnames;
handles.PATHNAME=pathname;


str=[];

if isstr(fnames)
    N=1;
else N=numel(fnames);
end
handles.N=N;
if N>0
    set(handles.pushbutton4,'enable','on');
else
    set(handles.pushbutton4,'enable','off');
end
str=[num2str(N) ' data files selected:'];
str2=[];
if N==1, str2=fnames;
else
    for i=1:N
        if i==1, str2=[str2 ' ' fnames{i}];
        else
            str2= [str2 ', ' fnames{i}];
        end
    end
end

set(handles.text3, 'string', [str str2]);
guidata(hObject, handles);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%set(handles.figure1, 'visible', 'off')
handles.FNAMES
for i=1:handles.N
    fname=handles.FNAMES{i};
    cd(handles.PATHNAME)
    load(fname,'filteredResponse');
    %% BOOKMARK-HARDCORDE
    filteredResponse.data=filteredResponse.data/max(filteredResponse.data);
    dual=0;
    if get(handles.checkbox1,'value')
        f=findSpikes_gui(filteredResponse,fname,dual)
        uiwait(f)
    end
    
    try
        load(fname,'filteredResponse2');
        dual=1;
        filteredResponse2.data=filteredResponse2.data/max(filteredResponse2.data);
        if get(handles.checkbox1,'value')
            f=findSpikes_gui(filteredResponse2,fname,dual)
            uiwait(f)
        end
    catch
    end
    
    
    
    load(fname,'Triggers','spikeFindingData');
    if get(handles.checkbox2,'value')
        f=findTriggers_gui(Triggers,spikeFindingData, fname)
        uiwait(f)
    end
    
    spikes=spikeFindingData.spikes;
    load(fname,'Conditions','spikeFindingData','RawResponse');
    if get(handles.checkbox3,'value')
        f=makePSTH_gui(Conditions,spikes,RawResponse,Triggers,spikeFindingData.ppms,fname)
        uiwait(f)
    end
    
    
    % do EPSP gui
    load(fname,'spikeFindingData','RawResponse');
    
    
    
    if get(handles.checkbox4,'value')
        
        load(fname,'EEG','Triggers');
    
        %clear Triggers
        if exist('EEG','var')
            niqf = spikeFindingData.ppms*1000/2;
            [b,a] = butter(2,[.04 500]/niqf);
            eeg=filtfilt(b,a,EEG.data);
            eeg=eeg-max(eeg);eeg=eeg/std(eeg);
        end
        
        if exist('Triggers','var') && exist('EEG','var')
            f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,handles.PATHNAME, eeg,Triggers)
            uiwait(f)
        elseif exist('Triggers','var')
            f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,handles.PATHNAME,0,Triggers)
            uiwait(f)
        elseif exist('EEG','var')
            f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,handles.PATHNAME,eeg)
            uiwait(f)
        else
            f=FindEPSPs_gui(RawResponse.data,spikeFindingData.ppms,fname,spikeFindingData.spikes,handles.PATHNAME)
            uiwait(f)
        end
        
    end
    
    
    
    
    %print examples
    if get(handles.checkbox5,'value')
        f=DataExampleGui([fname '.mat'],handles.PATHNAME)
        uiwait(f)
    end
    
    
    
    %do UDS analysis
    
    load(fname,'EEG','spikeFindingData');
    if get(handles.checkbox8,'value')
        
        
        
        f=UDS_gui(EEG.data,spikeFindingData.ppms,handles.PATHNAME,fname)
        
        
        uiwait(f)
    end
    
end


%read in user data
% handles.CONDITIONS=varargin{1};
% handles.SPIKES=varargin{2};
% handles.RAWRESPONSE=varargin{3};
% handles.TRIGGERS=varargin{4};
% handles.PPMS=varargin{5};
% handles.SAVEFILE=varargin{6};

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)
CEDS64CloseAll();
display('Quit analysis!')

% --- Executes on button press in pushbutton4.
%this function imports smr data to matlab and creates analysis files...it
%changes the fnames list to include ONLY dataXanalysis.mat for later use.
function pushbutton4_Callback(hObject, eventdata, handles)
% IMPORT Button
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N=handles.N;
fnames=handles.FNAMES;
newfnames={};
count=0;
for i=1:N
    if N==1,fname=fnames;else; fname=fnames{i};end
    %MAKE SURE MOVE TO CORRECT DIRECTORY
    index=strfind(fname,'.');
    ext=fname(index:end);
    fver = 32;
    if strcmp('.smr',ext)
        f=importSMR(fname,handles.PATHNAME,fver);
    elseif strcmp('.mat',ext)
        disp('MATLAB ''.mat'' file given')
    elseif strcmp('.smrx',ext)
        fver = 64;
        disp('New format found: ''.smrx''')
        f = importSMR(fname,handles.PATHNAME,fver);
        
    else
        disp('Unknown file!');
        break;
    end
    matfile=fname(1:(index-1));
    count=count+1;
    %if isempty(strfind(matfile,'analysis'))
    if ~contains(matfile,'analysis')
        CreateAnalysisFiles(handles.PATHNAME,matfile,1)
        newfnames{count}=[matfile 'analysis'];
    else
        newfnames{count}=matfile;
    end
end
newfnames=unique(newfnames);

if isstr(fnames)
    N=1;
else N=numel(fnames);
end

handles.FNAMES=newfnames;
handle.N=N;

set(handles.pushbutton2,'enable','on');

guidata(hObject, handles);

disp('New file list:')
for i=1:numel(newfnames)
    
    display(newfnames{i})
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton4.
function pushbutton4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
