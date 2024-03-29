########################################################################
##
## Copyright (C) 2018-2021 The Octave Project Developers
##
## See the file COPYRIGHT.md in the top-level directory of this
## distribution or <https://octave.org/copyright/>.
##
## This file is part of Octave.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.
##
########################################################################

## -*- texinfo -*-
## @deftypefn  {} {@var{response} =} webwrite (@var{url}, @var{name1}, @var{value1}, @dots{})
## @deftypefnx {} {@var{response} =} webwrite (@var{url}, @var{data})
## @deftypefnx {} {@var{response} =} webwrite (@dots{}, @var{options})
##
## Write data to RESTful web services.
##
## Write content to the web service specified by @var{url} and return the
## response in @var{response}.
##
## All key-value pairs given (@var{name1}, @var{value1}, @dots{}) are added
## as pairs of query parameters to the body of request method (@code{get},
## @code{post}, @code{put}, etc.).
##
## @var{options} is a @code{weboptions} object that may be used to add other
## HTTP request options.  This argument can be used with either calling form.
## See @code{help weboptions} for a complete list of supported HTTP options.
##
## @seealso{weboptions, webread}
## @end deftypefn

function response = webwriteNew(url, varargin)

  if (nargin < 2)
    print_usage();
  endif

  if (! (ischar (url) && isrow (url)))
    error ("webwrite: URL must be a string");
  endif

  if (isa (varargin{end}, "weboptionsNew"))
    has_weboptions = true;
    options = varargin{end};
    varargin(end) = [];
  else
    has_weboptions = false;
    options = weboptionsNew();
  endif

  if (strcmp (options.MediaType, "auto"))
    options.MediaType = "application/x-www-form-urlencoded";
  endif

  ## If MediaType is set by the user, append it to other headers.
  if (! strcmp (options.CharacterEncoding, "auto"))
      % fix for options.HeaderFields size
      options.HeaderFields(end+1, 1:2) = {"Content-Type",...
                                          [options.MediaType, ...
                                           "; charset=", options.CharacterEncoding]}; 
  endif

  if (! isempty (options.KeyName))
      % fix for options.HeaderFields size
      if iscell(options.KeyName)
          l = length(options.KeyName);
          if (size(options.KeyName,1) == 1)&&(l~=1)
              options.HeaderFields(end+1:end+l, 1:2) = [options.KeyName', options.KeyValue'];
          else
              options.HeaderFields(end+1:end+l, 1:2) = [options.KeyName, options.KeyValue];
          end
      else
          options.HeaderFields(end+1, 1:2) = {options.KeyName, options.KeyValue};
      endif
  endif

  if (strcmp (options.RequestMethod, "auto"))
    options.RequestMethod = "post";
  endif

  ## Flatten the cell array because the internal processing takes place on
  ## a flattened array.
  options.HeaderFields = reshape(options.HeaderFields',1,[]);

  nargs = numel(varargin);
  if (nargs == 0)
    error ("webwrite: DATA must be a string");
  elseif (nargs == 1)
    if (ischar (varargin{1}) && isrow (varargin{1}))
      param = strsplit (varargin{1}, {"=", "&"});
      response = __restful_service__ (url, param, options);
%    elseif  (! iscellstr (varargin))
%      error ("webwrite: DATA must be a string");
    else
      response = __restful_service__ (url, varargin{:}, options);
    endif
  elseif (rem (nargs, 2) == 0)
    if (! iscellstr (varargin))
      error ("webwrite: KEYS and VALUES must be strings");
    else
      response = __restful_service__ (url, varargin{:}, options);
    endif
  else
    error ("webwrite: KEYS/VALUES must occur in pairs");
  endif

endfunction


## Test input validation
%!error webwrite ()
%!error webwrite ("abc")
%!error <URL must be a string> webwrite (1, "NAME1", "VALUE1")
%!error <URL must be a string> webwrite (["a";"b"], "NAME1", "VALUE1")
%!error <DATA must be a string> webwrite ("URL", 1, weboptions ())
%!error <DATA must be a string> webwrite ("URL", 1)
%!error <KEYS and VALUES must be strings> webwrite ("URL", "NAME1", 5)
%!error <KEYS/VALUES must occur in pairs> webwrite ("URL", "KEY1", "VAL1", "A")

