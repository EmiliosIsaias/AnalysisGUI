function varargout = segregateRepeats(varargin)
% SEGREGATEREPEATS MATLAB code for segregateRepeats.fig
%      SEGREGATEREPEATS, by itself, creates a new SEGREGATEREPEATS or raises the existing
%      singleton*.
%
%      H = SEGREGATEREPEATS returns the handle to a new SEGREGATEREPEATS or the handle to
%      the existing singleton*.
%
%      SEGREGATEREPEATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGREGATEREPEATS.M with the given input arguments.
%
%      SEGREGATEREPEATS('Property','Value',...) creates a new SEGREGATEREPEATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segregateRepeats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segregateRepeats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segregateRepeats

% Last Modified by GUIDE v2.5 31-Jan-2011 00:03:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segregateRepeats_OpeningFcn, ...
                   'gui_OutputFcn',  @segregateRepeats_OutputFcn, ...
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


% --- Executes just before segregateRepeats is made visible.
function segregateRepeats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segregateRepeats (see VARARGIN)

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
handles.NEW={};
guidata(hObject, handles);
uiwait(handles.figure1);
% UIWAIT makes SplitRepeats wait for user response (see UIRESUME)


% --- Outputs from this function are returned to the command line.
function varargout = segregateRepeats_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
varargout{2} = handles.NEW;
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
    i
    if data{i,2}==1
        n=data{i,3};
        C=COND{i};
        SplitC={};
        for j=1:n
            SplitC{j}=C;
            SplitC{j}.Triggers=SplitC{j}.Triggers(j:n:end);
            SplitC{j}.name=[SplitC{j}.name 'r' num2str(j)];
        end
        NewConditions=[NewConditions SplitC(2:end)];
        COND{i}=SplitC{1};
    end
end
handles.NEW=[COND NewConditions];
display('New conditions created')
guidata(hObject,handles);     
uiresume(handles.figure1);
%close(gcf)
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);
