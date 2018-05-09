function varargout = SplitRepeats(varargin)
% SPLITREPEATS MATLAB code for SplitRepeats.fig
%      SPLITREPEATS, by itself, creates a new SPLITREPEATS or raises the existing
%      singleton*.
%
%      H = SPLITREPEATS returns the handle to a new SPLITREPEATS or the handle to
%      the existing singleton*.
%
%      SPLITREPEATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPLITREPEATS.M with the given input arguments.
%
%      SPLITREPEATS('Property','Value',...) creates a new SPLITREPEATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SplitRepeats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SplitRepeats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SplitRepeats

% Last Modified by GUIDE v2.5 29-Jan-2011 23:57:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SplitRepeats_OpeningFcn, ...
                   'gui_OutputFcn',  @SplitRepeats_OutputFcn, ...
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


% --- Executes just before SplitRepeats is made visible.
function SplitRepeats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SplitRepeats (see VARARGIN)

% Choose default command line output for SplitRepeats

handles.output=hObject;
Conditions=varargin{1};names={};
for i=1:numel(Conditions)
    names{i}=Conditions{i}.name;
end

handles.NAMES=names;
DATA=cell(numel(names),3);

for i=1:numel(names)
    DATA{i,1}=names{i};
    DATA{i,2}=0;
    DATA{i,3}=1;
end
handles.CONDITIONS=Conditions;
set(handles.uitable1,'data',DATA)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SplitRepeats wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SplitRepeats_OutputFcn(hObject, eventdata, handles) 
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

data=get(handles.uitable1,'data')
names=handles.NAMES;
repeated=[];
COND=handles.CONDITIONS;
NewConditions={};
for i=1:numel(names)
    if data{i,2}==1
        n=data{i,3};
        C=COND{i};
        SplitC={};
        for j=1:n
            SplitC{j}=C;
            SplitC{j}.Triggers=SplitC{j}.Triggers(j:n:end);
            SplitC{j}.name=[SplitC{j}.name 'repeat' num2str(j)];
        end
        NewConditions=[NewConditions SplitC(2:end)];
        COND{i}=SplitC{1};
    end
end
assignin('caller', 'Conditions', [COND NewConditions])
guidata(hObject,handles);     
close(gcf)
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);