% This file contains all the variables that should be modified at beginning of every cruise
%-----------------------------
 
struct_levels_to_print(0);

warning("off");

# set octave"s graphics_toolkit to the one that works...
graphics_toolkit("gnuplot");

%-----------------------------
CRUISE = "AMT25";
WAP_ROOT = strcat(lower(CRUISE),'b_15') ; % tjor: `root" part of WAP file 
#WAP_ROOT = strcat(lower(CRUISE),"b"); % tjor: `root" part of WAP file for <With_AC9_Without_ACS
%-----------------------------
% Variables to be changed during cruise according to specific setups and user needs
%
% Date
  
#inidate = "20150918"; 
#enddate = "20151102";

inidate = "20150925"; # testdate
enddate = "20150925";



% Hour of the day for which Wapped files are searched
% (day is not processed if a file for the specified hour is not found)
% Format is "0HH"
WAPhour = "019"; % tjor: `processes all days with 0XXth hour of data present"
#WAPhour = "007"; % for final day

% Underway subdirectory where to find special wapped data
% Leave with simple / if no special case
#UWAY_WAP_SUBDIR = "With_AC9_Without_ACS/"; 
#UWAY_WAP_SUBDIR = "With_AC9/"; 
UWAY_WAP_SUBDIR = "/"; 

% Parameters specific for Underway plotting/processing
% (this will change depending on specific section fo the cruise)
% Setup to automatically change based on UWAY_WAP_SUBDIR
%
% Implemented instruments to selct from are 
% {"ctd","acs","bb3","cstar","acs2","ac9","clam"}
#if strcmp (UWAY_WAP_SUBDIR, "With_AC9_Without_ACS/") == 1 % tjor: selects `bfiles" for 2018 cruise
   # dh8_instruments = {"ac9", "bb3", "cstar", "ctd"};
    % Ports must corresponds to same ports as in dh8_instruments
  #  dh8_ports = {1,2,3,4}; 
    % Serial numbers are mainly needed for acs and ac9 config files, leave blank for other instruments
 #   dh8_serialnumber = {227, 1173, 1426,[]};
if strcmp(UWAY_WAP_SUBDIR, "261/") == 1 % tjor: selects subdirectory with AC9
    dh8_instruments = {"acs", "acs2", "", "ctd"};
    % Ports must corresponds to same ports as in dh8_instruments
 #   dh8_ports = {1,2,3,4}; 
    % Serial numbers are mainly needed for acs and ac9 config files, leave blank for other instruments
#    dh8_serialnumber = {122, 1173, 227,[]};
else strcmp(UWAY_WAP_SUBDIR, "/") % tjor: this is the `default" config (i.e. without subdirectories inside WAP_extracted)
    dh8_instruments = {"acs", "acs2", "bb3", "cstar"};
    % Ports must corresponds to same ports as in dh8_instruments
    dh8_ports = {1,2,3,4}; 
    % Serial numbers are mainly needed for acs and ac9 config files, leave blank for other instruments
    dh8_serialnumber = {122, 167, 1173, ""}; 
endif
%-----------------------------

%-----------------------------
% Paths
MAIN_PATH = "/users/rsg/tjor/scratch_network/AMT_underway/AMT25/";

#MAIN_PATH = "/data/abitibi1/scratch/scratch_disk/tjor/AMT_underway/AMT26/"; disp("\n\n-----------THIS IS FOR TOM----------\n\n"); fflush(stdout);
%MAIN_PATH = "/tom/AMT_underway/AMT28/"; %disp("\n\n---------THIS IS FOR GIORGIO---------\n\n"); fflush(stdout);
#MAIN_PATH = "/fast_scratch/AMT28/"; disp("\n\n---------THIS IS FOR GIORGIO---------\n\n"); fflush(stdout);
% MAIN_PATH = [MAIN_PATH, "/Data/", CRUISE,"/"];     % Root directory for current AMT cruise
PATH_DATA = [MAIN_PATH, "Data/"];        % Directory with all raw and wapped data
#PATH_DATA  = "/data/datasets/cruise_data/active/AMT28/Optics_all/Optics/Data/";



PATH_SOURCE = [MAIN_PATH, "Source/"];% Directory with all source code
OUT_PROC = [MAIN_PATH, "Processed/"];    % Output directory for processed oct and mat files
OUT_FIGS = [MAIN_PATH, "Figures/"];      % Output directory for figures

addpath([PATH_SOURCE]);
%-----------------------------
% Each directory will contain a series of subdirectories for each instrument
% (e.g. Underway, Optics_rig, BB3_ctd etc. etc.)
OPTIC_DIR = "Optics_rig/";
UWAY_DIR = ["UWay/"]
BB3_DIR = "BB3_ctd/";
CTD_DIR = "Ship_CTD/";
% Specific data subdirectories
DATA_WAPPED = "WAP_Extracted/";
DATA_RAW = "Raw/";
DATA_FLOW = "Flow/";
#DATA_WITH_BB3 = "with_BB3/";


%-----------------------------
% calibration file dir
D_CAL_FILES = [MAIN_PATH "Cals/"]; # copied to scratch network 

%-----------------------------
% ACS calibration file
ACS_CAL_FILE_NAME = "acs122.dev";
ACS_CAL_FILE_NAME_2 = "acs167.dev";
%-----------------------------

%-----------------------------
% Ship"s system directories
PATH_SHIP = [PATH_DATA, "UWay/ancillary/ancillary/"]; %tjor - ships meteorological data
# PATH_TS = [PATH_SHIP, "Compress/"]; % Directory with ship underway ctd
PATH_TS = PATH_SHIP; # no compress directory for amt 26

#----------------------------
# Input parameters for ship"s underway data
# 
# here we assume that the ship"s uway data are always stored in daily folders called YYYYDOY (e.g., 2018290) 
addpath([MAIN_PATH, "Source/Underway/"]) # location where rd seatech and ocean logger functions are stored
DIR_GPS = PATH_TS;
GLOB_GPS = "2015\*";
FN_GPS = "seatex-gga.ACO";
FNC_GPS = @rd_seatech_gga; # this function should be inside Source/Underway

DIR_METDATA = PATH_TS;
GLOB_METDATA = "2015\*";
FN_METDATA = "oceanlogger.ACO";
FNC_METDATA = @rd_oceanloggerJCR; # this function should be inside Source/Underway

#----------------------------


# Path-related variables for step2
global DIR_STEP1 = [OUT_PROC UWAY_DIR "Step1/"];
global DIR_STEP2 = [OUT_PROC UWAY_DIR "Step2/"];
global DIR_STEP3 = [OUT_PROC UWAY_DIR "Step3/"];
global FN_ROOT_STEP2 = [DIR_STEP2 "proc_optics_" lower(CRUISE) "_"];

global acs_wv = [400:2:750];

% Create path for saving figures
#   global fig_dir = [OUT_FIGS, UWAY_DIR];
global DIR_FIGS = [OUT_FIGS, UWAY_DIR];

% Create directories if they do not exists
   if ~exist(DIR_FIGS, "dir")
      mkdir(DIR_FIGS);
   endif

   if ~exist(DIR_STEP2, "dir")
      mkdir(DIR_STEP2);
   endif







%-----------------------------
% Parameters specific for Optics rig plotting/processing
%
% Wether cdt is saved as ASCII format (false for AMT26; true for AMT27)
ctdASCII = true;
% Limits for temperature and salinity profiles
Tlim = [0 20];
Slim = [33 35];
% Limits for absorption and attenuation profiles
alim = [0.1 0.4];
clim = [0.05 0.6];
chlac9lim = [0 5];
%-----------------------------

% Processors to be used by parcellfun in run_step1par.m
NProc = nproc() - 1;

% Name of processed file to be saved
fproc_name = ["optics_" lower(CRUISE) "_"];

% Limits for time-series plots
acs_raw_lim = [-0.03 0.1]; % acs
flow_lim = [20 45];        % flow rate
bb3_lim = [50 140];       % backscattering
SST_lim = [15 20];         % CTD temperature
SSS_lim = [35 36.5];        % CTD salinity
% Limits for step2 time series
acs_lim = [-0.05 0.3];
ac9_lim = acs_lim;
bb_opt_lim = [70 150];
cstar_lim = [0.75 0.85];
spectra_alim = [0.03];
spectra_clim = [1];
chl_lim = [0.01 5];

%-----------------------------
% Parameters specific for BB3 plotting/processing
%
% Limits for bb3 profiles
bb3lim = [50 300];
%-----------------------------

%-----------------------------
% Parameters specific for underway transect
%
latlim = 54;
trans_SST = [01 30];
trans_SSS = [33 38];
trans_chl = [0.01 5];
trans_cp650 = [0.01 0.3];
%-----------------------------

%-----------------------------
% useful functions
movavg = inline("filter(1/mavgwd*ones(1, mavgwd), 1, x)", "x", "mavgwd"); % this is equivalent to a standard moving average with a window size of mavgwd
%-----------------------------





