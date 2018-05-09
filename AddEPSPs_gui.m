function varargout = AddEPSPs_gui(varargin)
% ADDEPSPS_GUI MATLAB code for AddEPSPs_gui.fig
%      ADDEPSPS_GUI, by itself, creates a new ADDEPSPS_GUI or raises the existing
%      singleton*.
%
%      H = ADDEPSPS_GUI returns the handle to a new ADDEPSPS_GUI or the handle to
%      the existing singleton*.
%
%      ADDEPSPS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDEPSPS_GUI.M with the given input arguments.
%
%      ADDEPSPS_GUI('Property','Value',...) creates a new ADDEPSPS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AddEPSPs_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AddEPSPs_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AddEPSPs_gui

% Last Modified by GUIDE v2.5 09-Jul-2013 14:27:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AddEPSPs_gui_OpeningFcn, ...
    'gui_OutputFcn',  @AddEPSPs_gui_OutputFcn, ...
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


% --- Executes just before AddEPSPs_gui is made visible.
function AddEPSPs_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AddEPSPs_gui (see VARARGIN)

% Choose default command line output for AddEPSPs_gui

handles.output = hObject;

handles.pV=varargin{1};

if ~isempty(varargin{2})
    handles.locs=varargin{2}(:,1);
    handles.peaks=varargin{2}(:,2);
else
    handles.locs=[];
    handles.peaks=[];
end
handles.ppms=varargin{3};
handles.savefile=varargin{4};
if ~isempty(varargin{2})
    handles.N=numel(varargin{2}(:,1));
else
    handles.N=0;
end
handles.window=varargin{5};
handles.NewEvents=varargin{6};
handles.startpoint=varargin{7};
guidata(hObject, handles);
handles.EEG=varargin{8};
handles.checkEvents=varargin{9};
handles.eegMult=varargin{10};
handles.L=varargin{11};
handles.W=varargin{12};



time=[1:numel(varargin{1})]/handles.ppms;
set(handles.text1,'String',handles.savefile)

%grab old added events, if they exist
if ~isempty(handles.NewEvents)
    starts=[handles.locs;handles.NewEvents(:,1)]
    peaks=[handles.peaks;handles.NewEvents(:,2)]
else
    starts=handles.locs;
    peaks=handles.peaks;
end

startV=handles.pV(starts);
peaksV=handles.pV(peaks);

continueStr='Click EPSP starts and peaks, return to continue:';
errorStr='ERROR: odd number of clicks. Please redo.';
eventhandle=plot(handles.axes1,time(10:10:end),handles.pV(10:10:end),'k', time(10:10:end),handles.EEG(10:10:end)*handles.eegMult-1.5,....
    time(10:10:end),handles.L(10:10:end)*3-15,'b', time(10:10:end),handles.W(10:10:end)*3-15,'g');
hold on
eventhandle2=plot(handles.axes1,starts/handles.ppms,startV,'co',peaks/handles.ppms,peaksV,'ro')


axes(handles.axes1);hold on;
set(eventhandle(2),'linewidth',2,'color',[.5 .5 .5]);
try
    set(eventhandle(3),'linewidth',2);
    set(eventhandle(4),'linewidth',2);
catch
end
M=max(time);

NewEvents=handles.NewEvents;
startpoint=round(handles.startpoint/100*M);
i1=0+startpoint;
i2=handles.window+startpoint;
ylim([min(handles.pV)-35 max(handles.pV)]);

lims=[i1 i2];
xlim(lims);
window=handles.window;
n=num2str(round(max(lims)/max(time)*1000)/10);
set(handles.text3,'String', n);

while max(lims)<(M+window*5)
    if handles.checkEvents
        h1=[];h2=[]; x1=[];x2=[];y1=[];y2=[];
        % go event by event if you want to
        
        [x1 y1]=ginput(1)
        
        if isempty(x1)
            lims=lims+window*.8
            xlim(lims);
            n=num2str(round(max(lims)/max(time)*1000)/10);
            set(handles.text3,'String', n)
        end
        
        if ~isempty(y1)
            if y1> max(get(handles.axes1,'ylim'))
                break
            end
        end
        
        if ~isempty(x1)
            newStartV=handles.pV(round(x1*handles.ppms));
            h1=plot(handles.axes1,x1,newStartV,'c*')
            set(h1,'linewidth',2,'markersize',15)
            
            [x2 y2]=ginput(1)
            if ~isempty(y2)
                if y1> max(get(handles.axes1,'ylim'))
                    break
                end
            end
            
            newPeakV=handles.pV(round(x2*handles.ppms));
            h2=plot(handles.axes1,x2,newPeakV,'r*')
            set(h2,'linewidth',2,'markersize',15)
            
        end
        
        choice='';
        if ~isempty(x1) &  ~isempty(x2)
            choice = questdlg('Do you want to accept the selected event?', ...
                'Acceptable EPSP?','GOOD','BAD','BAD')
        end
        
        if strcmp(choice,'GOOD')
            NewEvents=[NewEvents;[round(x1*handles.ppms) round(x2*handles.ppms)]];
            handles.NewEvents=NewEvents;
            guidata(hObject, handles);
            scoot=0;
            n=num2str(round(max(lims)/max(time)*1000)/10);
            set(handles.text3,'String', n)
        elseif strcmp(choice,'BAD')
            delete(h1)
            delete(h2)
        end
        
        
    else
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
        NewEvents=[NewEvents;[newstarts newpeaks]];
        lims=lims+window*.8;
        xlim(lims)
        
        handles.NewEvents=NewEvents;
        guidata(hObject, handles);
        
        n=num2str(round(max(lims)/max(time)*1000)/10);
        set(handles.text3,'String', n)
    end
    
    
    
end





try
    % Update handles structure
    guidata(hObject, handles);
catch
end

handSelectedEPSPs={};
handSelectedEPSPs.NewEvents=handles.NewEvents;

save(handles.savefile,'handSelectedEPSPs','-append')



% UIWAIT makes AddEPSPs_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AddEPSPs_gui_OutputFcn(hObject, eventdata, handles)
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


handSelectedEPSPs={};
handSelectedEPSPs.NewEvents=handles.NewEvents;

save(handles.savefile,'handSelectedEPSPs','-append')

close(handles.figure1)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
