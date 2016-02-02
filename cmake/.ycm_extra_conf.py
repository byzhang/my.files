import collections
import fnmatch
import os
from threading import Lock

from clang_helpers import PrepareClangFlags


def FindProjectRoot(filename):
    path = os.path.dirname(filename)
    while True:
        if os.path.exists(path + '/build'):
            return path

        if not path or path == '/':
            return None

        path = os.path.dirname(path)
    return None


def FindCompilationDatabaseLocation(filename):
    root = FindProjectRoot(filename)
    if root is None:
        return None
    if os.path.isfile(root + '/build/compile_commands.json'):
        return root + '/build/'
    return None


def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return flags
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        to_append = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                to_append = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                to_append = path_flag + os.path.join(working_directory, path)
                break

        if to_append:
            new_flags.append(to_append)
    return new_flags


def AddExtraFlags(flags, filename):
    flags.extend(['-I/usr/include/clang/3.4/include/',
                  '-I/usr/include/x86_64-linux-gnu/c++/4.9/',
                  '-I/usr/include/c++/4.9/'])
    # Without this, clang tries to compile .h files as C instead of C++
    # We still can't easily know what type of file a .h file is (C or C++?)
    if not IsCFile(filename):
        flags.extend(['-x', 'c++'])
    # The static-float-init flags are needed to work around a spurious warning
    # about constexpr coming from census-interface.h
    flags.extend(['-Wno-static-float-init',
                  '-Wno-gnu-static-float-init'])

    return flags


def RemoveFilenameIfPresent(flags, fudged_filename, original_filename):
    if fudged_filename != original_filename:
        return [x for x in flags if x != fudged_filename]
    return flags


def OutputForCompilationInfo(compilation_info,
                             fudged_filename,
                             original_filename):
    flags = RemoveFilenameIfPresent(
        PrepareClangFlags(
            MakeRelativePathsInFlagsAbsolute(
                compilation_info.compiler_flags_,
                compilation_info.compiler_working_dir_),
            fudged_filename),
        fudged_filename,
        original_filename)

    do_cache = bool(flags)

    if do_cache:
        flags = AddExtraFlags(flags, fudged_filename)

    return {
        'flags': flags,
        'do_cache': do_cache
    }


def IsHeaderFile(filename):
    return filename.endswith('.h')


def IsCFile(filename):
    return filename.endswith('.c')


def FindFilesRecursively(path, suffixes):
    matches = []
    for root, dirnames, filenames in os.walk(path):
        for suffix in suffixes:
            for filename in fnmatch.filter(filenames, '*.' + suffix):
                matches.append(os.path.join(root, filename))
    return matches


# Blaze does not have compilation flags for header files, but it does for the
# corresponding cc file.
def FudgeHeaderFileToCcFile(filename):
    root = FindProjectRoot(filename)
    if root is None:
        return None
    filenames = FindFilesRecursively(root, ['cpp', 'cc'])
    if len(filenames) == 0:
        return None
    return filenames[0]


def GetDatabaseForPath(path):
    # Can't be top-level because this file is sourced before ycm_core.so is
    # placed in the correct location with YcmCorePreload
    import ycm_core

    global _databases

    with _databases_lock:
        database = _databases[path]

    if not database:
        database = ycm_core.CompilationDatabase(path)
        with _databases_lock:
            _databases[path] = database

    return database


NO_FLAGS = {'flags': [], 'do_cache': False, 'flags_ready': False}

# access to this should be protected by the below lock!
_databases = collections.defaultdict(lambda: None)
_databases_lock = Lock()


def CompilationInfoForFile(filename):
    if filename is None:
        return None
    if not os.path.isfile(filename):
        return None

    compilation_db_root = FindCompilationDatabaseLocation(filename)
    if compilation_db_root is None:
        return None

    database = GetDatabaseForPath(compilation_db_root)
    if database.AlreadyGettingFlags():
        return None

    info = database.GetCompilationInfoForFile(filename)
    return info if info.compiler_flags_ else None


def FlagsForFile(filename):
    compilation_info = CompilationInfoForFile(filename)
    fudged_filename = filename

    # The idea here is that if we can't get the flags for a header file, then
    # try to get the flags for a corresponding CC file ('foo.cc' for 'foo.h').
    if not compilation_info:
        if IsHeaderFile(filename):
            fudged_filename = FudgeHeaderFileToCcFile(filename)
            compilation_info = CompilationInfoForFile(fudged_filename)
            if not compilation_info:
                return NO_FLAGS
        else:
            return NO_FLAGS

    return OutputForCompilationInfo(
        compilation_info, fudged_filename, filename)
