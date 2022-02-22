function varargout = ImageEnhancementGUI(varargin)
% IMAGEENHANCEMENTGUI MATLAB code for ImageEnhancementGUI.fig
%      IMAGEENHANCEMENTGUI, by itself, creates a new IMAGEENHANCEMENTGUI or raises the existing
%      singleton*.
%
%      H = IMAGEENHANCEMENTGUI returns the handle to a new IMAGEENHANCEMENTGUI or the handle to
%      the existing singleton*.
%
%      IMAGEENHANCEMENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEENHANCEMENTGUI.M with the given input arguments.
%
%      IMAGEENHANCEMENTGUI('Property','Value',...) creates a new IMAGEENHANCEMENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageEnhancementGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageEnhancementGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageEnhancementGUI

% Last Modified by GUIDE v2.5 28-Nov-2020 13:10:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEnhancementGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEnhancementGUI_OutputFcn, ...
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


% --- Executes just before ImageEnhancementGUI is made visible.
function ImageEnhancementGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageEnhancementGUI (see VARARGIN)

% Choose default command line output for ImageEnhancementGUI
handles.output = hObject;

% Initiate the image filepath variable
handles.filepath = '';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageEnhancementGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageEnhancementGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ClearImageButton.
function ClearImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
cla(handles.axes2,'reset')
title("Resulted Image")
% Update the handles data
guidata(hObject, handles);


% --- Executes on button press in SaveImageButton.
function SaveImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter = {'*.jpg';'*.bmp';'*.png'};
[file, path] = uiputfile(filter);
if isequal(file,0) || isequal(path,0)
   disp('User clicked Cancel.')
else
   disp(['User selected ',fullfile(path,file),...
         ' and then clicked Save.'])
end
handles.saveFilepath = fullfile(path, file);

% Write file to disk
imwrite(handles.result_img, handles.saveFilepath);

% Update the handles data
guidata(hObject, handles);



% --- Executes on button press in ChooseFileButton.
function ChooseFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uigetfile({'*.jpg';'*.png';'*.bmp'});
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
handles.filepath = fullfile(path, file);

% Set the filepath text to the edit text
set(handles.ChooseFileEditText, 'String', handles.filepath);

% Imshow the file choosen after squaring the image
ori_img = imread(handles.filepath);
handles.initial_img = SquareImg(ori_img, 400);
axes(handles.axes1);
imshow(handles.initial_img);
title("Original Image")

% Update the handles data
guidata(hObject, handles);

function ChooseFileEditText_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseFileEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChooseFileEditText as text
%        str2double(get(hObject,'String')) returns contents of ChooseFileEditText as a double



% --- Executes during object creation, after setting all properties.
function ChooseFileEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChooseFileEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButterworthFilterButton.
function ButterworthFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to ButterworthFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.result_img = ButterworthEnhancement(handles.initial_img);
% Update the handles data
guidata(hObject, handles);

% --- Executes on button press in GaussianFilterButton.
function GaussianFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to GaussianFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.result_img = GaussianEnhancement(handles.initial_img);
% Update the handles data
guidata(hObject, handles);

% --- Executes on selection change in FilterMenu.
function FilterMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FilterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FilterMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FilterMenu

contents = cellstr(get(hObject,'String'));
filter = contents{get(hObject,'Value')};

switch filter
    case 'Butterworth'
        handles.filter = 'Butterworth';
        disp(handles.filter);
    case 'Gaussian'
        handles.filter = 'Gaussian';
        disp(handles.filter);
end
% Update the handles data
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FilterMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LowHighMenu.
function LowHighMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LowHighMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LowHighMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LowHighMenu
contents = cellstr(get(hObject,'String'));
freq_level = contents{get(hObject,'Value')};

switch freq_level
    case 'Low'
        handles.freq_level = 'Low';
        disp(handles.freq_level);
    case 'High'
        handles.freq_level = 'High';
        disp(handles.freq_level);
end
% Update the handles data
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function LowHighMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowHighMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ThresholdFreqEditText_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdFreqEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThresholdFreqEditText as text
%        str2double(get(hObject,'String')) returns contents of ThresholdFreqEditText as a double
handles.threshold_freq = str2double(get(hObject, 'String'));
disp(handles.threshold_freq)
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function ThresholdFreqEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThresholdFreqEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ProcessImageButton.
function ProcessImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine filter selected
if isfield(handles, 'filter')
    if contains(handles.filter, 'Butterworth') || contains(handles.filter, 'Gaussian')
        handles.result_img = Filters(handles.initial_img, handles.filter,...
        handles.freq_level,handles.threshold_freq);
        disp('Filters called')
    end
end

axes(handles.axes2);
imshow(handles.result_img,[]);
title("Resulted Image")

% Clear handles data fields
handles.freq_level = '';
handles.threshold_freq = 0;
handles.filter = '';

% Update the handles data
guidata(hObject, handles);

% --- Executes on button press in FourierTransformButton.
function FourierTransformButton_Callback(hObject, eventdata, handles)
% hObject    handle to FourierTransformButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FourierTransformButton

% Fourier transform frequency domain 
handles.result_img = uint8(FourierTransform(handles.initial_img));

% Update the handles data
guidata(hObject, handles);


% --- Executes on button press in ArnoldTransformButton.
function ArnoldTransformButton_Callback(hObject, eventdata, handles)
% hObject    handle to ArnoldTransformButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ArnoldTransformButton
handles.result_img = ArnoldTransform(handles.initial_img);
% Update the handles data
guidata(hObject, handles);
