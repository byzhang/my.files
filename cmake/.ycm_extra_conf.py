import collections
import fnmatch
import os
from threading import Lock
from clang_helpers import PrepareClangFlags


# def _DirectoryOfThisScript():
#   return os.path.dirname( os.path.abspath( __file__ ) )


# def FindGoogle3ParentDir( path ):
#   google3_folder = path
#   while True:
#     if os.path.basename( google3_folder ) == 'google3':
#       break
#
#     if not google3_folder or google3_folder == '/':
#       return '/'
#
#     google3_folder = os.path.dirname( google3_folder )
#   return google3_folder


def FindProjectRoot( filename ):
  path = os.path.dirname( filename )
  while True:
    if os.path.exists( path + '/build'):
      return path

    if not path or path == '/':
      return None

    path = os.path.dirname( path )
  return None


def FindCompilationDatabaseLocation( filename ):
  root = FindProjectRoot(filename)
  if root is None:
    return None
  if os.path.isfile( root + '/build/compile_commands.json'):
    return root + '/build/'
  return None


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return flags
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    to_append = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        to_append = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        to_append = path_flag + os.path.join( working_directory, path )
        break

    if to_append:
      new_flags.append( to_append )
  return new_flags


# YCM_TEMP_DIR = os.path.join( tempfile.gettempdir(), 'ycm_temp' )
# YCM_PID_TEMP_DIR = os.path.join( YCM_TEMP_DIR, str( os.getpid() ) )


def AddExtraFlags( flags, filename ):
  # Without this, clang tries to compile .h files as C instead of C++
  # We still can't easily know what type of file a .h file is (C or C++?)
  if not IsCFile( filename ):
    flags.extend( ['-x', 'c++'] )
  # The static-float-init flags are needed to work around a spurious warning
  # about constexpr coming from census-interface.h
  # Seems relevant: https://b.corp.google.com/issue?id=8089224
  flags.extend( ['-Wno-static-float-init',
                  '-Wno-gnu-static-float-init' ] )

  # google3_folder = FindGoogle3ParentDir( filename )
  # For some reason Blaze is not adding the folder of the file as an include
  # path anymore...
  # if google3_folder != '/':
  #   flags =  ['-I', google3_folder ] + flags
  return flags


# If we "fudged" the filename (i.e. changed "foo.h" to "foo.cc" so that we can
# get the flags from blaze), we need to make sure that "foo.cc" is not in the
# list of flags we hand back.
def RemoveFilenameIfPresent( flags, fudged_filename, original_filename ):
  if fudged_filename != original_filename:
    return [x for x in flags if x != fudged_filename];
  return flags


def OutputForCompilationInfo( compilation_info,
                              fudged_filename,
                              original_filename ):
  flags = RemoveFilenameIfPresent(
              PrepareClangFlags(
                  MakeRelativePathsInFlagsAbsolute(
                      compilation_info.compiler_flags_,
                      compilation_info.compiler_working_dir_ ),
                  fudged_filename ),
              fudged_filename,
              original_filename )

  do_cache = bool( flags )

  if do_cache:
    flags = AddExtraFlags( flags, fudged_filename )

  return {
    'flags': flags,
    'do_cache': do_cache
  }


def IsHeaderFile( filename ):
  return filename.endswith( '.h' )


def IsCFile( filename ):
  return filename.endswith( '.c' )


def FindFilesRecursively(path, suffixes):
  matches = []
  for root, dirnames, filenames in os.walk(path):
    for suffix in suffixes:
      for filename in fnmatch.filter(filenames, '*.' + suffix):
        matches.append(os.path.join(root, filename))
  return matches


# Blaze does not have compilation flags for header files, but it does for the
# corresponding cc file.
def FudgeHeaderFileToCcFile( filename ):
  root = FindProjectRoot(filename)
  if root is None:
    return None
  filenames = FindFilesRecursively(root, ['cpp', 'cc'])
  if len(filenames) == 0:
    return None
  return filenames[0]


def GetDatabaseForPath( path ):
  # Can't be top-level because this file is sourced before ycm_core.so is placed
  # in the correct location with YcmCorePreload
  import ycm_core

  global _databases

  with _databases_lock:
    database = _databases[ path ]

  if not database:
    database = ycm_core.CompilationDatabase( path )
    with _databases_lock:
      _databases[ path ] = database

  return database


NO_FLAGS = { 'flags': [], 'do_cache': False, 'flags_ready': False }

# path to google3 dir -> database object
# access to this should be protected by the below lock!
_databases = collections.defaultdict( lambda: None )
_databases_lock = Lock()


def CompilationInfoForFile( filename ):
  if filename is None:
    return None
  if not os.path.isfile( filename ):
    return None

  compilation_db_root = FindCompilationDatabaseLocation( filename )
  if compilation_db_root is None:
    return None

  database = GetDatabaseForPath( compilation_db_root )
  if database.AlreadyGettingFlags():
    return None

  info = database.GetCompilationInfoForFile( filename )
  return info if info.compiler_flags_ else None


def FlagsForFile( filename ):
  compilation_info = CompilationInfoForFile( filename )
  fudged_filename = filename

  # The idea here is that if we can't get the flags for a header file, the
  # reason might be because the user hasn't put that header file in the "hdrs"
  # section of a build target. This is unfortunately common in google3, so we
  # try to get the flags for a corresponding CC file ('foo.cc' for 'foo.h').
  if not compilation_info:
    if IsHeaderFile( filename ):
      fudged_filename = FudgeHeaderFileToCcFile( filename )
      compilation_info = CompilationInfoForFile( fudged_filename )
      if not compilation_info:
        return NO_FLAGS
    else:
      return NO_FLAGS

  return OutputForCompilationInfo( compilation_info, fudged_filename, filename )
