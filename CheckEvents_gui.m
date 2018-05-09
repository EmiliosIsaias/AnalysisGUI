function varargout = CheckEvents_gui(varargin)
% CHECKEVENTS_GUI MATLAB code for CheckEvents_gui.fig
%      CHECKEVENTS_GUI, by itself, creates a new CHECKEVENTS_GUI or raises the existing
%      singleton*.
%
%      H = CHECKEVENTS_GUI returns the handle to a new CHECKEVENTS_GUI or the handle to
%      the existing singleton*.
%
%      CHECKEVENTS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECKEVENTS_GUI.M with the given input arguments.
%
%      CHECKEVENTS_GUI('Property','Value',...) creates a new CHECKEVENTS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CheckEvents_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CheckEvents_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CheckEvents_gui

% Last Modified by GUIDE v2.5 28-Feb-2013 18:05:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CheckEvents_gui_OpeningFcn, ...
    'gui_OutputFcn',  @CheckEvents_gui_OutputFcn, ...
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


% --- Executes just before CheckEvents_gui is made visible.
function CheckEvents_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CheckEvents_gui (see VARARGIN)

% Choose default command line output for CheckEvents_gui
handles.output = hObject;
handles.pV=varargin{1};
handles.locs=varargin{2}(:,1);
handles.peaks=varargin{2}(:,2);
handles.ppms=varargin{3};
handles.savefile=varargin{4};
handles.N=numel(varargin{2}(:,1));
handles.window=varargin{5};
set(handles.text1,'String',handles.savefile)
global STATUS
STATUS='go'
guidata(hObject, handles);


%



% Update handles structure


% UIWAIT makes CheckEvents_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CheckEvents_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%ACCEPT EVENT
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STATUS
STATUS='accept';
uiresume

%REJECT EVENT
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global STATUS
STATUS='reject'
uiresume

%ACCEPT REMAINING AND QUIT
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global STATUS
STATUS='quit'
uiresume

% START
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STATUS
timeAfter=round(handles.window*handles.ppms);
timeBefore=-round(timeAfter*.5);
trigs=handles.locs;

pV=[zeros(-timeBefore,1);handles.pV;zeros(timeAfter,1)];
handles.trigV=TriggeredSegments(pV, handles.locs-timeBefore, timeBefore,timeAfter);
handles.goods=ones(size(handles.locs));
%time in msp
handles.time=[timeBefore:timeAfter]/handles.ppms;

guidata(hObject, handles);

N=numel(handles.locs);
counter=0;
while ~strcmp(STATUS,'quit')  && counter< N
    counter=counter+1;
    peak=handles.peaks(counter);
    start=handles.locs(counter);
    shiftpeak=peak-start;
    p=plot(handles.axes1, handles.time,handles.trigV(:,counter),'k',...
        0,handles.pV(start),'oc',...
        shiftpeak/handles.ppms,handles.pV(peak),'or')
    set(p,'linewidth',2)
    n=round(counter/handles.N*1000)/10;
    set(handles.text2, 'String', num2str(n));
    
    axes(handles.axes1)
    ylim([min(handles.pV-2) max(handles.pV)+2])
   
    uiwait

    
    switch STATUS
        case 'accept'
        case 'reject'
            handles.goods(counter)=0;
            guidata(hObject, handles);
    end

    
end


checkedEPSPData={};
checkedEPSPData.goods=handles.goods
save(handles.savefile,'checkedEPSPData','-append');
close(handles.figure1);



