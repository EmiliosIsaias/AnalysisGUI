function varargout = CheckClusters_gui(varargin)
% CHECKCLUSTERS_GUI MATLAB code for CheckClusters_gui.fig
%      CHECKCLUSTERS_GUI, by itself, creates a new CHECKCLUSTERS_GUI or raises the existing
%      singleton*.
%
%      H = CHECKCLUSTERS_GUI returns the handle to a new CHECKCLUSTERS_GUI or the handle to
%      the existing singleton*.
%
%      CHECKCLUSTERS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECKCLUSTERS_GUI.M with the given input arguments.
%
%      CHECKCLUSTERS_GUI('Property','Value',...) creates a new CHECKCLUSTERS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CheckClusters_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CheckClusters_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CheckClusters_gui

% Last Modified by GUIDE v2.5 17-Jul-2013 18:05:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CheckClusters_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @CheckClusters_gui_OutputFcn, ...
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


% --- Executes just before CheckClusters_gui is made visible.
function CheckClusters_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CheckClusters_gui (see VARARGIN)

% Choose default command line output for CheckClusters_gui
handles.output = hObject;


handles.mags=varargin{1};
handles.rtime=varargin{2};
handles.vstart=varargin{3};
handles.savefile=varargin{4};
guidata(hObject, handles);
guidata(hObject, handles);
axes(handles.axes1)
s=scatter(handles.mags, handles.rtime,10,handles.vstart);
set(s,'linewidth',2);
xlim([0 max(handles.mags)*1.1])
ylim([0 max(handles.rtime)*1.1])
title(handles.savefile)
ylabel('rise time [ms]')
xlabel('magnitude [mV]')
brush on
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CheckClusters_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CheckClusters_gui_OutputFcn(hObject, eventdata, handles) 
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

axes(handles.axes1);
hBrushLine = findall(gca,'tag','Brushing');
brushedData = get(hBrushLine, {'Xdata','Ydata'});
exclude = find(~isnan(brushedData{1}))


save(handles.savefile,'exclude','-append')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)


if ~strcmp(get(handles.axes1,'yscale'),'log')
set(handles.axes1,'yscale','log','xscale','log')
else
    set(handles.axes1,'yscale','linear','xscale','linear')
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f=figure
s=scatter(handles.mags, handles.rtime,25,handles.vstart);
set(s,'linewidth',2);
xlim([0 max(handles.mags)*1.1])
ylim([0 max(handles.rtime)*1.1])
title(handles.savefile)
ylabel('rise time [ms]')
xlabel('magnitude [mV]')
set(gcf, 'PaperPositionmode', 'auto')
print(f, 'magnitudes', '-dpdf')

