function varargout = HandPickUp_gui(varargin)
% HANDPICKUP_GUI MATLAB code for HandPickUp_gui.fig
%      HANDPICKUP_GUI, by itself, creates a new HANDPICKUP_GUI or raises the existing
%      singleton*.
%
%      H = HANDPICKUP_GUI returns the handle to a new HANDPICKUP_GUI or the handle to
%      the existing singleton*.
%
%      HANDPICKUP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HANDPICKUP_GUI.M with the given input arguments.
%
%      HANDPICKUP_GUI('Property','Value',...) creates a new HANDPICKUP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HandPickUp_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HandPickUp_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HandPickUp_gui

% Last Modified by GUIDE v2.5 17-Jul-2013 16:13:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @HandPickUp_gui_OpeningFcn, ...
    'gui_OutputFcn',  @HandPickUp_gui_OutputFcn, ...
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


% --- Executes just before HandPickUp_gui is made visible.
function HandPickUp_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HandPickUp_gui (see VARARGIN)

% Choose default command line output for HandPickUp_gui

handles.output = hObject;
handles.pV=varargin{1};
if ~isempty(varargin{2})
    handles.locs=varargin{2}(:,1);
else
    handles.locs=[];
    
end
handles.ppms=varargin{3};
handles.savefile=varargin{4};
if ~isempty(varargin{2})
    handles.N=numel(varargin{2}(:,1));
else
    handles.N=0;
end
handles.window=varargin{5};
handles.HandUp=varargin{6};
handles.startpoint=varargin{7};
handles.W=varargin{8};
handles.L=varargin{9};
guidata(hObject, handles);




time=[1:numel(varargin{1})]/handles.ppms;
set(handles.text1,'String',handles.savefile)

%grab old added events, if they exist
if ~isempty(handles.HandUp)
    starts=[handles.locs;handles.HandUp(:,1)]
else
    starts=handles.locs;
end

startV=handles.pV(starts);
continueStr='Click LFP Up time and min time, return to continue:';
errorStr='ERROR: odd number of clicks. Please redo.';
eventhandle=plot(handles.axes1,time(10:10:end),handles.pV(10:10:end),'k',time(10:10:end),handles.W(10:10:end),'g',time(10:10:end),handles.L(10:10:end),'b');

hold on
eventhandle2=plot(handles.axes1,starts/handles.ppms,startV,'co','linewidth',4)

axes(handles.axes1);hold on;
M=max(time);

HandUp=handles.HandUp;
startpoint=round(handles.startpoint/100*M);
i1=0+startpoint;
i2=handles.window+startpoint;
ylim([min(handles.pV) max(handles.pV)]);

lims=[i1 i2];
xlim(lims);
window=handles.window;
n=num2str(round(max(lims)/max(time)*1000)/10);
set(handles.text3,'String', n);

while max(lims)<(M+window*5)
    [x y]=ginput;
    %catch errors, odd number of clicks
    while mod(numel(x),2)~=0
        set(handles.text2,'String', errorStr);
        [x y]=ginput;
    end
    
    set(handles.text2,'String', continueStr);
    newstarts=round(x(1:2:end)*handles.ppms);
    newpeaks=round(x(2:2:end)*handles.ppms);
    
    newStartV=handles.pV(newstarts);
    newPeakV=handles.pV(newpeaks);
    h=plot(handles.axes1,newstarts/handles.ppms,newStartV,'c*',newpeaks/handles.ppms,newPeakV,'r*')
    set(h,'linewidth',4,'markersize',20)
    HandUp=[HandUp;[newstarts newpeaks]];
    lims=lims+window*.8;
    xlim(lims)
    yseg=handles.pV(round(lims(1)*handles.ppms):round(lims(2)*handles.ppms));
    m1=min(yseg);m2=max(yseg)
    ylim([m1-abs(m1)*.2 m2+abs(m2)*.2])
    handles.HandUp=HandUp;
    guidata(hObject, handles);
    
    n=num2str(round(max(lims)/max(time)*1000)/10);
    set(handles.text3,'String', n)
end

try
    % Update handles structure
    guidata(hObject, handles);
catch
end

HandUp=handles.HandUp;

save(handles.savefile,'HandUp','-append')



% UIWAIT makes HandPickUp_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HandPickUp_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HandUp=handles.HandUp;

save(handles.savefile,'HandUp','-append')

close(handles.figure1)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
