-- premake5.lua
SRC_ROOT = "../build/crashpad"
mig_script = SRC_ROOT..'/util/mach/mig.py'

-- FIXME detect automatically
sysroot = '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk'

workspace "Crashpad"
  configurations { "Release" }
  language "C++"
  cppdialect "C++14"
  includedirs {
    SRC_ROOT,
    SRC_ROOT.."/third_party/mini_chromium/mini_chromium"
  }
  filter "configurations:Release"
    defines { "NDEBUG" }
    optimize "On"
    symbols "On"
  filter {}

  flags {
  }

  filter "system:macosx"
    defines {
    }
    includedirs {
      SRC_ROOT.."/compat/mac",
      SRC_ROOT.."/compat/non_win",
    }
    buildoptions { "-mmacosx-version-min=10.9" }
  filter {}

project "minichromium_base"
  kind "StaticLib"
  MINICHROMIUM_BASE_ROOT = SRC_ROOT.."/third_party/mini_chromium/mini_chromium/base"

  files {
    MINICHROMIUM_BASE_ROOT.."/debug/alias.cc",
    MINICHROMIUM_BASE_ROOT.."/files/file_path.cc",
    MINICHROMIUM_BASE_ROOT.."/files/scoped_file.cc",
    MINICHROMIUM_BASE_ROOT.."/logging.cc",
    MINICHROMIUM_BASE_ROOT.."/process/memory.cc",
    MINICHROMIUM_BASE_ROOT.."/rand_util.cc",
    MINICHROMIUM_BASE_ROOT.."/strings/string16.cc",
    MINICHROMIUM_BASE_ROOT.."/strings/string_number_conversions.cc",
    MINICHROMIUM_BASE_ROOT.."/strings/stringprintf.cc",
    MINICHROMIUM_BASE_ROOT.."/strings/utf_string_conversion_utils.cc",
    MINICHROMIUM_BASE_ROOT.."/strings/utf_string_conversions.cc",
    MINICHROMIUM_BASE_ROOT.."/synchronization/lock.cc",
    MINICHROMIUM_BASE_ROOT.."/third_party/icu/icu_utf.cc",
    MINICHROMIUM_BASE_ROOT.."/threading/thread_local_storage.cc",
  }

  filter "system:macosx"
    files {
      MINICHROMIUM_BASE_ROOT.."/mac/foundation_util.mm",
      MINICHROMIUM_BASE_ROOT.."/mac/close_nocancel.cc",
      MINICHROMIUM_BASE_ROOT.."/mac/mach_logging.cc",
      MINICHROMIUM_BASE_ROOT.."/mac/scoped_mach_port.cc",
      MINICHROMIUM_BASE_ROOT.."/mac/scoped_mach_vm.cc",
      MINICHROMIUM_BASE_ROOT.."/mac/scoped_nsautorelease_pool.mm",
      MINICHROMIUM_BASE_ROOT.."/strings/sys_string_conversions_mac.mm",

      -- Posix
      MINICHROMIUM_BASE_ROOT.."/files/file_util_posix.cc",
      MINICHROMIUM_BASE_ROOT.."/posix/safe_strerror.cc",
      MINICHROMIUM_BASE_ROOT.."/process/process_metrics_posix.cc",
      MINICHROMIUM_BASE_ROOT.."/synchronization/lock_impl_posix.cc",
      MINICHROMIUM_BASE_ROOT.."/threading/thread_local_storage_posix.cc",
      -- end posix
    }

project "client"
  kind "StaticLib"

  files {
    SRC_ROOT.."/client/annotation.cc",
    SRC_ROOT.."/client/annotation_list.cc",
    SRC_ROOT.."/client/crash_report_database.cc",
    SRC_ROOT.."/client/crashpad_info.cc",
    SRC_ROOT.."/client/settings.cc",
    SRC_ROOT.."/client/prune_crash_reports.cc",
  }

  filter "system:macosx"
    files {
      SRC_ROOT.."/client/crash_report_database_mac.mm",
      SRC_ROOT.."/client/crashpad_client_mac.cc",
      SRC_ROOT.."/client/simulate_crash_mac.cc",
    }


project "util"
  kind "StaticLib"

  files {
    SRC_ROOT.."/util/file/delimited_file_reader.cc",
    SRC_ROOT.."/util/file/file_io.cc",
    SRC_ROOT.."/util/file/file_reader.cc",
    SRC_ROOT.."/util/file/file_seeker.cc",
    SRC_ROOT.."/util/file/file_writer.cc",
    SRC_ROOT.."/util/file/scoped_remove_file.cc",
    SRC_ROOT.."/util/file/string_file.cc",
    SRC_ROOT.."/util/misc/initialization_state_dcheck.cc",
    SRC_ROOT.."/util/misc/lexing.cc",
    SRC_ROOT.."/util/misc/metrics.cc",
    SRC_ROOT.."/util/misc/pdb_structures.cc",
    SRC_ROOT.."/util/misc/random_string.cc",
    SRC_ROOT.."/util/misc/range_set.cc",
    SRC_ROOT.."/util/misc/reinterpret_bytes.cc",
    SRC_ROOT.."/util/misc/scoped_forbid_return.cc",
    SRC_ROOT.."/util/misc/time.cc",
    SRC_ROOT.."/util/misc/uuid.cc",
    SRC_ROOT.."/util/misc/zlib.cc",
    SRC_ROOT.."/util/net/http_body.cc",
    SRC_ROOT.."/util/net/http_body_gzip.cc",
    SRC_ROOT.."/util/net/http_multipart_builder.cc",
    SRC_ROOT.."/util/net/http_transport.cc",
    SRC_ROOT.."/util/net/url.cc",
    SRC_ROOT.."/util/numeric/checked_address_range.cc",
    SRC_ROOT.."/util/process/process_memory.cc",
    SRC_ROOT.."/util/process/process_memory_range.cc",
    SRC_ROOT.."/util/stdlib/aligned_allocator.cc",
    SRC_ROOT.."/util/stdlib/string_number_conversion.cc",
    SRC_ROOT.."/util/stdlib/strlcpy.cc",
    SRC_ROOT.."/util/stdlib/strnlen.cc",
    SRC_ROOT.."/util/string/split_string.cc",
    SRC_ROOT.."/util/thread/thread.cc",
    SRC_ROOT.."/util/thread/thread_log_messages.cc",
    SRC_ROOT.."/util/thread/worker_thread.cc",
  }

  filter {"system:macosx", "files:**/child_port.defs"}
    outputs = {
      'gen/util/mach/child_portUser.c',
      'gen/util/mach/child_portServer.c',
      'gen/util/mach/child_port.h',
      'gen/util/mach/child_portServer.h',
    }
    buildmessage 'Processing %{file.relpath}'
    buildcommands {
      '{MKDIR} gen/util/mach',
      string.format("python %s --include %s --sdk %s %s %s",
        mig_script,
        SRC_ROOT..'/compat/mac',
        sysroot,
        '%{file.relpath}',
        table.concat(outputs, ' ')
      ),
    }
    buildoutputs { outputs }

  filter {"system:macosx", "files:**/notify.defs"}
    outputs = {
      'gen/util/mach/notifyUser.c',
      'gen/util/mach/notifyServer.c',
      'gen/util/mach/notify.h',
      'gen/util/mach/notifyServer.h',
    }
    buildmessage 'Processing %{file.relpath}'
    buildcommands {
      '{MKDIR} gen/util/mach',
      string.format("python %s --include %s --sdk %s %s %s",
        mig_script,
        SRC_ROOT..'/compat/mac',
        sysroot,
        '%{file.relpath}',
        table.concat(outputs, ' ')
      ),
    }
    buildoutputs { outputs }

  filter {"system:macosx", "files:**/mach_exc.defs"}
    outputs = {
      'gen/util/mach/mach_excUser.c',
      'gen/util/mach/mach_excServer.c',
      'gen/util/mach/mach_exc.h',
      'gen/util/mach/mach_excServer.h',
    }
    buildmessage 'Processing %{file.relpath}'
    buildcommands {
      '{MKDIR} gen/util/mach',
      string.format("python %s --include %s --sdk %s %s %s",
        mig_script,
        SRC_ROOT..'/compat/mac',
        sysroot,
        '%{file.relpath}',
        table.concat(outputs, ' ')
      ),
    }
    buildoutputs { outputs }

  filter {"system:macosx", "files:**/exc.defs"}
    outputs = {
      'gen/util/mach/excUser.c',
      'gen/util/mach/excServer.c',
      'gen/util/mach/exc.h',
      'gen/util/mach/excServer.h',
    }
    buildmessage 'Processing %{file.relpath}'
    buildcommands {
      '{MKDIR} gen/util/mach',
      string.format("python %s --include %s --sdk %s %s %s",
        mig_script,
        SRC_ROOT..'/compat/mac',
        sysroot,
        '%{file.relpath}',
        table.concat(outputs, ' ')
      ),
    }
    buildoutputs { outputs }

  filter "system:macosx"
    defines {
      "CRASHPAD_ZLIB_SOURCE_SYSTEM"
    }

    gen_dir = "gen"

    includedirs {gen_dir}

    files {
      SRC_ROOT.."/util/mac/launchd.mm",
      SRC_ROOT.."/util/mac/mac_util.cc",
      SRC_ROOT.."/util/mac/service_management.cc",
      SRC_ROOT.."/util/mac/xattr.cc",
      SRC_ROOT.."/util/mach/child_port_handshake.cc",
      SRC_ROOT.."/util/mach/child_port_server.cc",
      SRC_ROOT.."/util/mach/composite_mach_message_server.cc",
      SRC_ROOT.."/util/mach/exc_client_variants.cc",
      SRC_ROOT.."/util/mach/exc_server_variants.cc",
      SRC_ROOT.."/util/mach/exception_behaviors.cc",
      SRC_ROOT.."/util/mach/exception_ports.cc",
      SRC_ROOT.."/util/mach/exception_types.cc",
      SRC_ROOT.."/util/mach/mach_extensions.cc",
      SRC_ROOT.."/util/mach/mach_message.cc",
      SRC_ROOT.."/util/mach/mach_message_server.cc",
      SRC_ROOT.."/util/mach/notify_server.cc",
      SRC_ROOT.."/util/mach/scoped_task_suspend.cc",
      SRC_ROOT.."/util/mach/symbolic_constants_mach.cc",
      SRC_ROOT.."/util/mach/task_for_pid.cc",
      SRC_ROOT.."/util/misc/capture_context_mac.S",
      SRC_ROOT.."/util/misc/clock_mac.cc",
      SRC_ROOT.."/util/misc/paths_mac.cc",
      SRC_ROOT.."/util/net/http_transport_mac.mm",
      SRC_ROOT.."/util/posix/process_info_mac.cc",
      SRC_ROOT.."/util/process/process_memory_mac.cc",
      SRC_ROOT.."/util/synchronization/semaphore_mac.cc",

      -- MIG inputs
      SRC_ROOT..'/util/mach/child_port.defs',
      sysroot..'/usr/include/mach/notify.defs',
      sysroot..'/usr/include/mach/mach_exc.defs',
      sysroot..'/usr/include/mach/exc.defs',

      -- End MIG inputs

      -- MIG
      gen_dir.."/util/mach/excUser.c",
      gen_dir.."/util/mach/excServer.c",
      gen_dir.."/util/mach/mach_excUser.c",
      gen_dir.."/util/mach/mach_excServer.c",
      gen_dir.."/util/mach/notifyUser.c",
      gen_dir.."/util/mach/notifyServer.c",
      gen_dir.."/util/mach/child_portUser.c",
      gen_dir.."/util/mach/child_portServer.c",
      -- End MIG

      -- Posix
      SRC_ROOT.."/util/file/directory_reader_posix.cc",
      SRC_ROOT.."/util/file/file_io_posix.cc",
      SRC_ROOT.."/util/file/filesystem_posix.cc",
      SRC_ROOT.."/util/misc/clock_posix.cc",
      SRC_ROOT.."/util/posix/close_stdio.cc",
      SRC_ROOT.."/util/posix/scoped_dir.cc",
      SRC_ROOT.."/util/posix/scoped_mmap.cc",
      SRC_ROOT.."/util/posix/signals.cc",
      SRC_ROOT.."/util/synchronization/semaphore_posix.cc",
      SRC_ROOT.."/util/thread/thread_posix.cc",
      SRC_ROOT.."/util/posix/close_multiple.cc",
      SRC_ROOT.."/util/posix/double_fork_and_exec.cc",
      SRC_ROOT.."/util/posix/drop_privileges.cc",
      SRC_ROOT.."/util/posix/symbolic_constants_posix.cc",
      -- End posix
    }

project "snapshot"
  kind "StaticLib"
  files {
    SRC_ROOT.."/snapshot/annotation_snapshot.cc",
    SRC_ROOT.."/snapshot/capture_memory.cc",
    SRC_ROOT.."/snapshot/cpu_context.cc",
    SRC_ROOT.."/snapshot/crashpad_info_client_options.cc",
    SRC_ROOT.."/snapshot/handle_snapshot.cc",
    SRC_ROOT.."/snapshot/memory_snapshot.cc",
    SRC_ROOT.."/snapshot/minidump/memory_snapshot_minidump.cc",
    SRC_ROOT.."/snapshot/minidump/minidump_annotation_reader.cc",
    SRC_ROOT.."/snapshot/minidump/minidump_simple_string_dictionary_reader.cc",
    SRC_ROOT.."/snapshot/minidump/minidump_string_list_reader.cc",
    SRC_ROOT.."/snapshot/minidump/minidump_string_reader.cc",
    SRC_ROOT.."/snapshot/minidump/module_snapshot_minidump.cc",
    SRC_ROOT.."/snapshot/minidump/process_snapshot_minidump.cc",
    SRC_ROOT.."/snapshot/minidump/system_snapshot_minidump.cc",
    SRC_ROOT.."/snapshot/minidump/thread_snapshot_minidump.cc",
    SRC_ROOT.."/snapshot/unloaded_module_snapshot.cc",
  }

  filter "system:macosx"
    files {
      SRC_ROOT.."/snapshot/mac/cpu_context_mac.cc",
      SRC_ROOT.."/snapshot/mac/exception_snapshot_mac.cc",
      SRC_ROOT.."/snapshot/mac/mach_o_image_annotations_reader.cc",
      SRC_ROOT.."/snapshot/mac/mach_o_image_reader.cc",
      SRC_ROOT.."/snapshot/mac/mach_o_image_segment_reader.cc",
      SRC_ROOT.."/snapshot/mac/mach_o_image_symbol_table_reader.cc",
      SRC_ROOT.."/snapshot/mac/module_snapshot_mac.cc",
      SRC_ROOT.."/snapshot/mac/process_reader_mac.cc",
      SRC_ROOT.."/snapshot/mac/process_snapshot_mac.cc",
      SRC_ROOT.."/snapshot/mac/process_types.cc",
      SRC_ROOT.."/snapshot/mac/process_types/all.proctype",
      SRC_ROOT.."/snapshot/mac/process_types/annotation.proctype",
      SRC_ROOT.."/snapshot/mac/process_types/crashpad_info.proctype",
      SRC_ROOT.."/snapshot/mac/process_types/crashreporterclient.proctype",
      SRC_ROOT.."/snapshot/mac/process_types/custom.cc",
      SRC_ROOT.."/snapshot/mac/process_types/dyld_images.proctype",
      SRC_ROOT.."/snapshot/mac/process_types/loader.proctype",
      SRC_ROOT.."/snapshot/mac/process_types/nlist.proctype",
      SRC_ROOT.."/snapshot/mac/system_snapshot_mac.cc",
      SRC_ROOT.."/snapshot/mac/thread_snapshot_mac.cc",

      -- Posix
      SRC_ROOT.."/snapshot/posix/timezone.cc",
      -- End posix
    }

project "minidump"
  kind "StaticLib"
  files {
    SRC_ROOT.."/minidump/minidump_annotation_writer.cc",
    SRC_ROOT.."/minidump/minidump_byte_array_writer.cc",
    SRC_ROOT.."/minidump/minidump_context_writer.cc",
    SRC_ROOT.."/minidump/minidump_crashpad_info_writer.cc",
    SRC_ROOT.."/minidump/minidump_exception_writer.cc",
    SRC_ROOT.."/minidump/minidump_extensions.cc",
    SRC_ROOT.."/minidump/minidump_file_writer.cc",
    SRC_ROOT.."/minidump/minidump_handle_writer.cc",
    SRC_ROOT.."/minidump/minidump_memory_info_writer.cc",
    SRC_ROOT.."/minidump/minidump_memory_writer.cc",
    SRC_ROOT.."/minidump/minidump_misc_info_writer.cc",
    SRC_ROOT.."/minidump/minidump_module_crashpad_info_writer.cc",
    SRC_ROOT.."/minidump/minidump_module_writer.cc",
    SRC_ROOT.."/minidump/minidump_rva_list_writer.cc",
    SRC_ROOT.."/minidump/minidump_simple_string_dictionary_writer.cc",
    SRC_ROOT.."/minidump/minidump_stream_writer.cc",
    SRC_ROOT.."/minidump/minidump_string_writer.cc",
    SRC_ROOT.."/minidump/minidump_system_info_writer.cc",
    SRC_ROOT.."/minidump/minidump_thread_id_map.cc",
    SRC_ROOT.."/minidump/minidump_thread_writer.cc",
    SRC_ROOT.."/minidump/minidump_unloaded_module_writer.cc",
    SRC_ROOT.."/minidump/minidump_user_extension_stream_data_source.cc",
    SRC_ROOT.."/minidump/minidump_user_stream_writer.cc",
    SRC_ROOT.."/minidump/minidump_writable.cc",
    SRC_ROOT.."/minidump/minidump_writer_util.cc",
  }

project "crashpad_handler"
  kind "ConsoleApp"
  targetdir "bin/%{cfg.buildcfg}"
  links {
    "minichromium_base", "client", "util",
    "snapshot", "minidump",
  }

  -- System stuff
  links {
    "ApplicationServices.framework",
    "CoreFoundation.framework",
    "Foundation.framework",
    "IOKit.framework",
    "Security.framework",
    "bsm",
    "z",
  }

  files {
    SRC_ROOT.."/handler/main.cc",
    SRC_ROOT.."/tools/tool_support.cc",

    SRC_ROOT.."/handler/crash_report_upload_thread.cc",
    SRC_ROOT.."/handler/handler_main.cc",
    SRC_ROOT.."/handler/minidump_to_upload_parameters.cc",
    SRC_ROOT.."/handler/prune_crash_reports_thread.cc",
    SRC_ROOT.."/handler/user_stream_data_source.cc",
  }

  filter "system:macosx"

    files {
      SRC_ROOT.."/handler/mac/crash_report_exception_handler.cc",
      SRC_ROOT.."/handler/mac/exception_handler_server.cc",
      SRC_ROOT.."/handler/mac/file_limit_annotation.cc",
    }

  removefiles {
    SRC_ROOT.."/src/**/*_unittest.cc",
    SRC_ROOT.."/src/**/*_test.cc",
  }

project "crash"
  kind "ConsoleApp"
  targetdir "bin/%{cfg.buildcfg}"
  links {
    "minichromium_base",
    "util",
    "client",
  }

  -- System stuff
  links {
    "ApplicationServices.framework",
    "CoreFoundation.framework",
    "Foundation.framework",
    "IOKit.framework",
    "Security.framework",
    "bsm",
    "z",
  }

  dependson {"crashpad_handler"}

  filter "system:macosx"
    files {
      "./examples/mac/crash.cc",
    }

  filter "system:linux"
    links {"pthread"}
    files {
      "./examples/linux/crash.cc",
    }

  filter "system:windows"
    files {
      "./examples/windows/crash.cc",
    }

  filter {}


-- project "custom"
--   kind "StaticLib"

--   filter 'files:**/*.defs'
--     -- A message to display while this build step is running (optional)
--     buildmessage 'Compiling %{file.relpath}'

--     -- One or more commands to run (required)
--     buildcommands {
--         'touch ./bla'
--     }

--     -- One or more outputs resulting from the build (required)
--     buildoutputs { './bla' }

--     -- One or more additional dependencies for this build command (optional)
--     -- buildinputs { 'path/to/file1.ext', 'path/to/file2.ext' }
--   filter {}

--   filedef = string.format("%s/usr/include/mach/exc.defs", sysroot)
--   print(filedef)

--   files {
--     filedef,
--     '1'..filedef,
--     SRC_ROOT.."/minidump/minidump_annotation_writer.cc",
--   }
