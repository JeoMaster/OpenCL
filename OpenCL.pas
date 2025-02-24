unit OpenCL;

interface

{$IFDEF FPC}
  {$MODE Delphi} // Define o modo Delphi para compatibilidade com Free Pascal
{$ELSE}
  {$IFDEF FMX}
    {$DEFINE NO_VCL} // Desativa recursos VCL em projetos FireMonkey
  {$ENDIF}
{$ENDIF}

uses
  SysUtils;

{$IFDEF CL_HPP_OPENCL_API_WRAPPER}
{$ELSE}
{$ENDIF}

{$IFNDEF CL_HPP_USE_DX_INTEROP}
  {$IFDEF USE_DX_INTEROP}
    {$MESSAGE Warn 'USE_DX_INTEROP está depreciado. Defina CL_HPP_USE_DX_INTEROP em vez disso.'}
    {$DEFINE CL_HPP_USE_DX_INTEROP}
  {$ENDIF}
{$ENDIF}

{$IFNDEF CL_HPP_ENABLE_EXCEPTIONS}
  {$IFDEF __CL_ENABLE_EXCEPTIONS}
    {$MESSAGE Warn '__CL_ENABLE_EXCEPTIONS está depreciado. Defina CL_HPP_ENABLE_EXCEPTIONS em vez disso.'}
    {$DEFINE CL_HPP_ENABLE_EXCEPTIONS}
  {$ENDIF}
{$ENDIF}

{$IFNDEF CL_HPP_NO_STD_VECTOR}
  {$IFDEF __NO_STD_VECTOR}
    {$MESSAGE Warn '__NO_STD_VECTOR está depreciado. Defina CL_HPP_NO_STD_VECTOR em vez disso.'}
    {$DEFINE CL_HPP_NO_STD_VECTOR}
  {$ENDIF}
{$ENDIF}

{$IFNDEF CL_HPP_NO_STD_STRING}
  {$IFDEF __NO_STD_STRING}
    {$MESSAGE Warn '__NO_STD_STRING está depreciado. Defina CL_HPP_NO_STD_STRING em vez disso.'}
    {$DEFINE CL_HPP_NO_STD_STRING}
  {$ENDIF}
{$ENDIF}

{$IFDEF VECTOR_CLASS}
  {$MESSAGE Warn 'VECTOR_CLASS está depreciado. Use um alias para TArray ou similar em vez disso.'}
{$ENDIF}

{$IFDEF STRING_CLASS}
  {$MESSAGE Warn 'STRING_CLASS está depreciado. Use string em vez disso.'}
{$ENDIF}

{$IFNDEF CL_HPP_USER_OVERRIDE_ERROR_STRINGS}
  {$IFDEF __CL_USER_OVERRIDE_ERROR_STRINGS}
    {$MESSAGE Warn '__CL_USER_OVERRIDE_ERROR_STRINGS está depreciado. Defina CL_HPP_USER_OVERRIDE_ERROR_STRINGS em vez disso.'}
    {$DEFINE CL_HPP_USER_OVERRIDE_ERROR_STRINGS}
  {$ENDIF}
{$ENDIF}

{$IFDEF __USE_DEV_VECTOR}
  {$MESSAGE Warn '__USE_DEV_VECTOR não é mais suportado. Espere erros de compilação.'}
{$ENDIF}

{$IFDEF __USE_DEV_STRING}
  {$MESSAGE Warn '__USE_DEV_STRING não é mais suportado. Espere erros de compilação.'}
{$ENDIF}

{$IFNDEF CL_HPP_TARGET_OPENCL_VERSION}
  {$MESSAGE Hint 'CL_HPP_TARGET_OPENCL_VERSION não definida. Será definida como 300 (OpenCL 3.0) por padrão.'}
  {$DEFINE CL_HPP_TARGET_OPENCL_VERSION=300}
{$ENDIF}

{$IF NOT (CL_HPP_TARGET_OPENCL_VERSION = 100) AND
     NOT (CL_HPP_TARGET_OPENCL_VERSION = 110) AND
     NOT (CL_HPP_TARGET_OPENCL_VERSION = 120) AND
     NOT (CL_HPP_TARGET_OPENCL_VERSION = 200) AND
     NOT (CL_HPP_TARGET_OPENCL_VERSION = 210) AND
     NOT (CL_HPP_TARGET_OPENCL_VERSION = 220) AND
     NOT (CL_HPP_TARGET_OPENCL_VERSION = 300)}
  {$MESSAGE Warn 'CL_HPP_TARGET_OPENCL_VERSION não é um valor válido (100, 110, 120, 200, 210, 220 ou 300). Será redefinida para 300 (OpenCL 3.0).'}
  {$UNDEF CL_HPP_TARGET_OPENCL_VERSION}
  {$DEFINE CL_HPP_TARGET_OPENCL_VERSION=300}
{$ENDIF}

{$IFNDEF CL_HPP_MINIMUM_OPENCL_VERSION}
  {$DEFINE CL_HPP_MINIMUM_OPENCL_VERSION=100}
{$ENDIF}

{$IF CL_HPP_MINIMUM_OPENCL_VERSION < 110}
  {$MESSAGE Warn 'opencl.hpp requer pelo menos OpenCL 1.1. Defina CL_HPP_MINIMUM_OPENCL_VERSION >= 110 ou use uma versão mais antiga destas bindings.'}
{$ENDIF}

{$IF CL_HPP_TARGET_OPENCL_VERSION >= 100}
  {$DEFINE CL_VERSION_1_0}
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 110}
  {$DEFINE CL_VERSION_1_1}
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 120}
  {$DEFINE CL_VERSION_1_2}
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 200}
  {$DEFINE CL_VERSION_2_0}
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 210}
  {$DEFINE CL_VERSION_2_1}
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 220}
  {$DEFINE CL_VERSION_2_2}
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 300}
  {$DEFINE CL_VERSION_3_0}
{$ENDIF}

const
  CL_SFIXED14_UINT32_MAX = $3FFF;
  CL_SFIXED14_INT32_MAX  = $1FFF;
  CL_SFIXED14_INT32_MIN  = -$2000;

type
  Tcl_platform_id = type Pointer;
  Pcl_platform_id = ^Tcl_platform_id;
  Tcl_device_id = type Pointer;
  Pcl_device_id = ^Tcl_device_id;
  Tcl_context = type Pointer;
  Pcl_context = ^Tcl_context;
  Tcl_command_queue = type Pointer;
  Pcl_command_queue = ^Tcl_command_queue;
  Tcl_mem = type Pointer;
  Pcl_mem = ^Tcl_mem;
  Tcl_event = type Pointer;
  Pcl_event = ^Tcl_event;
  Tcl_kernel = type Pointer;
  Pcl_kernel = ^Tcl_kernel;
  Tcl_program = type Pointer;
  Pcl_program = ^Tcl_program;
  Tcl_sampler = type Pointer;
  Pcl_sampler = ^Tcl_sampler;

  Tcl_char = ShortInt;
  Pcl_char = ^Tcl_char;
  Tcl_uchar = Byte;
  Pcl_uchar = ^Tcl_uchar;
  Tcl_short = SmallInt;
  Pcl_short = ^Tcl_short;
  Tcl_ushort = Word;
  Pcl_ushort = ^Tcl_ushort;
  Tcl_int = Integer;
  Pcl_int = ^Tcl_int;
  Tcl_uint = Cardinal;
  Pcl_uint = ^Tcl_uint;
  Tcl_long = Int64;
  Pcl_long = ^Tcl_long;
  Tcl_ulong = UInt64;
  Pcl_ulong = ^Tcl_ulong;
  Tcl_float = Single;
  Pcl_float = ^Tcl_float;
  Tcl_double = Double;
  Pcl_double = ^Tcl_double;

  {$IFNDEF CL_HPP_ENABLE_SIZE_T_COMPATIBILITY}
    Tcl_size_t = NativeUInt;
  {$ELSE}
    Tcl_size_t = Cardinal;
  {$ENDIF}
  Pcl_size_t = ^Tcl_size_t;

  Tcl_device_type = Tcl_ulong;
  Pcl_device_type = ^Tcl_device_type;
  Tcl_context_properties = Tcl_long;
  Pcl_context_properties = ^Tcl_context_properties;
  Tcl_queue_properties = Tcl_long;
  Pcl_queue_properties = ^Tcl_queue_properties;
  Tcl_mem_flags = Tcl_ulong;
  Pcl_mem_flags = ^Tcl_mem_flags;
  Tcl_bool = Tcl_int;
  Pcl_bool = ^Tcl_bool;
  Tcl_platform_info = Tcl_uint;
  Pcl_platform_info = ^Tcl_platform_info;
  Tcl_device_info = Tcl_uint;
  Pcl_device_info = ^Tcl_device_info;
  Tcl_context_info = Tcl_uint;
  Pcl_context_info = ^Tcl_context_info;
  Tcl_command_queue_info = Tcl_uint;
  Pcl_command_queue_info = ^Tcl_command_queue_info;
  Tcl_program_info = Tcl_uint;
  Pcl_program_info = ^Tcl_program_info;
  Tcl_program_build_info = Tcl_uint;
  Pcl_program_build_info = ^Tcl_program_build_info;
  Tcl_kernel_info = Tcl_uint;
  Pcl_kernel_info = ^Tcl_kernel_info;
  Tcl_event_info = Tcl_uint;
  Pcl_event_info = ^Tcl_event_info;
  Tcl_sampler_info = Tcl_uint;
  Pcl_sampler_info = ^Tcl_sampler_info;
  Tcl_addressing_mode = Tcl_uint;
  Pcl_addressing_mode = ^Tcl_addressing_mode;
  Tcl_filter_mode = Tcl_uint;
  Pcl_filter_mode = ^Tcl_filter_mode;
  Tcl_command_type = Tcl_uint;
  Pcl_command_type = ^Tcl_command_type;

  Tcl_error_code = Tcl_int;

  Tcl_image_format = record
    image_channel_order: Tcl_uint;
    image_channel_data_type: Tcl_uint;
  end;
  Pcl_image_format = ^Tcl_image_format;

  Tcl_image_desc = record
    image_type: Tcl_mem_object_type;
    image_width: Tcl_size_t;
    image_height: Tcl_size_t;
    image_depth: Tcl_size_t;
    image_array_size: Tcl_size_t;
    image_row_pitch: Tcl_size_t;
    image_slice_pitch: Tcl_size_t;
    num_mip_levels: Tcl_uint;
    num_samples: Tcl_uint;
    buffer: Tcl_mem;
  end;
  Pcl_image_desc = ^Tcl_image_desc;

const
  CL_SUCCESS = 0;
  CL_DEVICE_NOT_FOUND = -1;
  CL_DEVICE_NOT_AVAILABLE = -2;
  CL_COMPILER_NOT_AVAILABLE = -3;
  CL_MEM_OBJECT_ALLOCATION_FAILURE = -4;
  CL_OUT_OF_RESOURCES = -5;
  CL_OUT_OF_HOST_MEMORY = -6;
  CL_PROFILING_INFO_NOT_AVAILABLE = -7;
  CL_MEM_COPY_OVERLAP = -8;
  CL_IMAGE_FORMAT_MISMATCH = -9;
  CL_IMAGE_FORMAT_NOT_SUPPORTED = -10;
  CL_BUILD_PROGRAM_FAILURE = -11;
  CL_MAP_FAILURE = -12;
  CL_MISALIGNED_SUB_BUFFER_OFFSET = -13;
  CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = -14;
  CL_COMPILE_PROGRAM_FAILURE = -15;
  CL_LINKER_NOT_AVAILABLE = -16;
  CL_LINK_PROGRAM_FAILURE = -17;
  CL_DEVICE_PARTITION_FAILED = -18;
  CL_KERNEL_ARG_INFO_NOT_AVAILABLE = -19;
  CL_INVALID_VALUE = -30;
  CL_INVALID_DEVICE_TYPE = -31;
  CL_INVALID_PLATFORM = -32;
  CL_INVALID_DEVICE = -33;
  CL_INVALID_CONTEXT = -34;
  CL_INVALID_QUEUE_PROPERTIES = -35;
  CL_INVALID_COMMAND_QUEUE = -36;
  CL_INVALID_HOST_PTR = -37;
  CL_INVALID_MEM_OBJECT = -38;
  CL_INVALID_IMAGE_FORMAT_DESCRIPTOR = -39;
  CL_INVALID_IMAGE_SIZE = -40;
  CL_INVALID_SAMPLER = -41;
  CL_INVALID_BINARY = -42;
  CL_INVALID_BUILD_OPTIONS = -43;
  CL_INVALID_PROGRAM = -44;
  CL_INVALID_PROGRAM_EXECUTABLE = -45;
  CL_INVALID_KERNEL_NAME = -46;
  CL_INVALID_KERNEL_DEFINITION = -47;
  CL_INVALID_KERNEL = -48;
  CL_INVALID_ARG_INDEX = -49;
  CL_INVALID_ARG_VALUE = -50;
  CL_INVALID_ARG_SIZE = -51;
  CL_INVALID_KERNEL_ARGS = -52;
  CL_INVALID_WORK_DIMENSION = -53;
  CL_INVALID_WORK_GROUP_SIZE = -54;
  CL_INVALID_WORK_ITEM_SIZE = -55;
  CL_INVALID_GLOBAL_OFFSET = -56;
  CL_INVALID_EVENT_WAIT_LIST = -57;
  CL_INVALID_EVENT = -58;
  CL_INVALID_OPERATION = -59;
  CL_INVALID_GL_OBJECT = -60;
  CL_INVALID_BUFFER_SIZE = -61;
  CL_INVALID_MIP_LEVEL = -62;
  CL_INVALID_GLOBAL_WORK_SIZE = -63;
  CL_INVALID_PROPERTY = -64;
  CL_INVALID_IMAGE_DESCRIPTOR = -65;
  CL_INVALID_COMPILER_OPTIONS = -66;
  CL_INVALID_LINKER_OPTIONS = -67;
  CL_INVALID_DEVICE_PARTITION_COUNT = -68;

type
  TCLPlatform = class;
  TCLDevice = class;
  TCLContext = class;
  TCLCommandQueue = class;
  TCLProgram = class;
  TCLKernel = class;
  TCLMemory = class;
  TCLBuffer = class;
  TCLEvent = class;
  TCLSampler = class;

{$IFDEF CL_HPP_ENABLE_EXCEPTIONS}
  TCLError = class(Exception)
  private
    FErr: Tcl_int;
    FErrStr: string;
  public
    constructor Create(err: Tcl_int; errStr: PAnsiChar = nil);
    function Err: Tcl_int;
  end;
{$ENDIF}

{$IFNDEF CL_HPP_USER_OVERRIDE_ERROR_STRINGS}
function ErrorString(error: Tcl_int): string;
{$ENDIF}

{$IFDEF CL_HPP_ENABLE_EXCEPTIONS}
procedure ErrChk(err: Tcl_int; operation: PAnsiChar);
{$ENDIF}

type
  TclGetPlatformIDs_fn = function(
    num_entries: Tcl_uint; platforms: Pcl_platform_id; num_platforms: Pcl_uint): Tcl_int; stdcall;

  TclGetPlatformInfo_fn = function(
    platform: Tcl_platform_id; param_name: Tcl_platform_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclGetDeviceIDs_fn = function(
    platform: Tcl_platform_id; device_type: Tcl_device_type; num_entries: Tcl_uint;
    devices: Pcl_device_id; num_devices: Pcl_uint): Tcl_int; stdcall;

  TclGetDeviceInfo_fn = function(
    device: Tcl_device_id; param_name: Tcl_device_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclCreateContext_fn = function(
    properties: Pcl_context_properties; num_devices: Tcl_uint; devices: Pcl_device_id;
    pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall;
    user_data: Pointer; errcode_ret: Pcl_int): Tcl_context; stdcall;

  TclCreateContextFromType_fn = function(
    properties: Pcl_context_properties; device_type: Tcl_device_type;
    pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall;
    user_data: Pointer; errcode_ret: Pcl_int): Tcl_context; stdcall;

  TclRetainContext_fn = function(context: Tcl_context): Tcl_int; stdcall;

  TclReleaseContext_fn = function(context: Tcl_context): Tcl_int; stdcall;

  TclGetContextInfo_fn = function(
    context: Tcl_context; param_name: Tcl_context_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclCreateCommandQueue_fn = function(
    context: Tcl_context; device: Tcl_device_id; properties: Tcl_queue_properties;
    errcode_ret: Pcl_int): Tcl_command_queue; stdcall;

  TclRetainCommandQueue_fn = function(command_queue: Tcl_command_queue): Tcl_int; stdcall;

  TclReleaseCommandQueue_fn = function(command_queue: Tcl_command_queue): Tcl_int; stdcall;

  TclGetCommandQueueInfo_fn = function(
    command_queue: Tcl_command_queue; param_name: Tcl_command_queue_info;
    param_value_size: Tcl_size_t; param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclCreateBuffer_fn = function(
    context: Tcl_context; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer;
    errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclRetainMemObject_fn = function(memobj: Tcl_mem): Tcl_int; stdcall;

  TclReleaseMemObject_fn = function(memobj: Tcl_mem): Tcl_int; stdcall;

  TclEnqueueReadBuffer_fn = function(
    command_queue: Tcl_command_queue; buffer: Tcl_mem; blocking_read: Tcl_bool; offset: Tcl_size_t;
    size: Tcl_size_t; ptr: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event;
    event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueWriteBuffer_fn = function(
    command_queue: Tcl_command_queue; buffer: Tcl_mem; blocking_write: Tcl_bool; offset: Tcl_size_t;
    size: Tcl_size_t; ptr: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event;
    event: Pcl_event): Tcl_int; stdcall;

  TclCreateProgramWithSource_fn = function(
    context: Tcl_context; count: Tcl_uint; strings: PPAnsiChar; lengths: Pcl_size_t;
    errcode_ret: Pcl_int): Tcl_program; stdcall;

  TclRetainProgram_fn = function(program: Tcl_program): Tcl_int; stdcall;

  TclReleaseProgram_fn = function(program: Tcl_program): Tcl_int; stdcall;

  TclBuildProgram_fn = function(
    program: Tcl_program; num_devices: Tcl_uint; device_list: Pcl_device_id;
    options: PAnsiChar; pfn_notify: procedure(program: Tcl_program; user_data: Pointer); stdcall;
    user_data: Pointer): Tcl_int; stdcall;

  TclCreateKernel_fn = function(
    program: Tcl_program; kernel_name: PAnsiChar; errcode_ret: Pcl_int): Tcl_kernel; stdcall;

  TclCreateKernelsInProgram_fn = function(
    program: Tcl_program; num_kernels: Tcl_uint; kernels: Pcl_kernel; num_kernels_ret: Pcl_uint): Tcl_int; stdcall;

  TclRetainKernel_fn = function(kernel: Tcl_kernel): Tcl_int; stdcall;

  TclReleaseKernel_fn = function(kernel: Tcl_kernel): Tcl_int; stdcall;

  TclSetKernelArg_fn = function(
    kernel: Tcl_kernel; arg_index: Tcl_uint; arg_size: Tcl_size_t; arg_value: Pointer): Tcl_int; stdcall;

  TclGetKernelInfo_fn = function(
    kernel: Tcl_kernel; param_name: Tcl_kernel_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclEnqueueNDRangeKernel_fn = function(
    command_queue: Tcl_command_queue; kernel: Tcl_kernel; work_dim: Tcl_uint;
    global_work_offset: Pcl_size_t; global_work_size: Pcl_size_t; local_work_size: Pcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclWaitForEvents_fn = function(
    num_events: Tcl_uint; event_list: Pcl_event): Tcl_int; stdcall;

  TclGetEventInfo_fn = function(
    event: Tcl_event; param_name: Tcl_event_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclRetainEvent_fn = function(event: Tcl_event): Tcl_int; stdcall;

  TclReleaseEvent_fn = function(event: Tcl_event): Tcl_int; stdcall;

  TclCreateSampler_fn = function(
    context: Tcl_context; normalized_coords: Tcl_bool; addressing_mode: Tcl_addressing_mode;
    filter_mode: Tcl_filter_mode; errcode_ret: Pcl_int): Tcl_sampler; stdcall;

  TclRetainSampler_fn = function(sampler: Tcl_sampler): Tcl_int; stdcall;

  TclReleaseSampler_fn = function(sampler: Tcl_sampler): Tcl_int; stdcall;

  TclGetSamplerInfo_fn = function(
    sampler: Tcl_sampler; param_name: Tcl_sampler_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclFinish_fn = function(command_queue: Tcl_command_queue): Tcl_int; stdcall;

  TclFlush_fn = function(command_queue: Tcl_command_queue): Tcl_int; stdcall;

  TclEnqueueCopyBuffer_fn = function(
    command_queue: Tcl_command_queue; src_buffer: Tcl_mem; dst_buffer: Tcl_mem;
    src_offset: Tcl_size_t; dst_offset: Tcl_size_t; size: Tcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueMapBuffer_fn = function(
    command_queue: Tcl_command_queue; buffer: Tcl_mem; blocking_map: Tcl_bool;
    map_flags: Tcl_mem_flags; offset: Tcl_size_t; size: Tcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event;
    errcode_ret: Pcl_int): Pointer; stdcall;

  TclEnqueueUnmapMemObject_fn = function(
    command_queue: Tcl_command_queue; memobj: Tcl_mem; mapped_ptr: Pointer;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueMarker_fn = function(
    command_queue: Tcl_command_queue; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueBarrier_fn = function(command_queue: Tcl_command_queue): Tcl_int; stdcall;

{$IFDEF CL_VERSION_1_1}
  TclCreateSubBuffer_fn = function(
    buffer: Tcl_mem; flags: Tcl_mem_flags; buffer_create_type: Tcl_uint;
    buffer_create_info: Pointer; errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclGetKernelWorkGroupInfo_fn = function(
    kernel: Tcl_kernel; device: Tcl_device_id; param_name: Tcl_kernel_work_group_info;
    param_value_size: Tcl_size_t; param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclEnqueueReadBufferRect_fn = function(
    command_queue: Tcl_command_queue; buffer: Tcl_mem; blocking_read: Tcl_bool;
    buffer_offset: Pcl_size_t; host_offset: Pcl_size_t; region: Pcl_size_t;
    buffer_row_pitch: Tcl_size_t; buffer_slice_pitch: Tcl_size_t;
    host_row_pitch: Tcl_size_t; host_slice_pitch: Tcl_size_t;
    ptr: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event;
    event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueWriteBufferRect_fn = function(
    command_queue: Tcl_command_queue; buffer: Tcl_mem; blocking_write: Tcl_bool;
    buffer_offset: Pcl_size_t; host_offset: Pcl_size_t; region: Pcl_size_t;
    buffer_row_pitch: Tcl_size_t; buffer_slice_pitch: Tcl_size_t;
    host_row_pitch: Tcl_size_t; host_slice_pitch: Tcl_size_t;
    ptr: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event;
    event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueCopyBufferRect_fn = function(
    command_queue: Tcl_command_queue; src_buffer: Tcl_mem; dst_buffer: Tcl_mem;
    src_offset: Pcl_size_t; dst_offset: Pcl_size_t; region: Pcl_size_t;
    src_row_pitch: Tcl_size_t; src_slice_pitch: Tcl_size_t;
    dst_row_pitch: Tcl_size_t; dst_slice_pitch: Tcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclCreateUserEvent_fn = function(
    context: Tcl_context; errcode_ret: Pcl_int): Tcl_event; stdcall;

  TclSetUserEventStatus_fn = function(
    event: Tcl_event; execution_status: Tcl_int): Tcl_int; stdcall;

  TclSetEventCallback_fn = function(
    event: Tcl_event; command_exec_callback_type: Tcl_int;
    pfn_notify: procedure(event: Tcl_event; event_command_status: Tcl_int; user_data: Pointer); stdcall;
    user_data: Pointer): Tcl_int; stdcall;
{$ENDIF}

{$IFDEF CL_VERSION_1_2}
  TclCreateProgramWithBinary_fn = function(
    context: Tcl_context; num_devices: Tcl_uint; device_list: Pcl_device_id;
    lengths: Pcl_size_t; binaries: PPcl_uchar; binary_status: Pcl_int;
    errcode_ret: Pcl_int): Tcl_program; stdcall;

  TclCreateImage_fn = function(
    context: Tcl_context; flags: Tcl_mem_flags; image_format: Pcl_image_format;
    image_desc: Pcl_image_desc; host_ptr: Pointer; errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclGetImageInfo_fn = function(
    image: Tcl_mem; param_name: Tcl_image_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclEnqueueReadImage_fn = function(
    command_queue: Tcl_command_queue; image: Tcl_mem; blocking_read: Tcl_bool;
    origin: Pcl_size_t; region: Pcl_size_t; row_pitch: Tcl_size_t; slice_pitch: Tcl_size_t;
    ptr: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event;
    event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueWriteImage_fn = function(
    command_queue: Tcl_command_queue; image: Tcl_mem; blocking_write: Tcl_bool;
    origin: Pcl_size_t; region: Pcl_size_t; row_pitch: Tcl_size_t; slice_pitch: Tcl_size_t;
    ptr: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event;
    event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueCopyImage_fn = function(
    command_queue: Tcl_command_queue; src_image: Tcl_mem; dst_image: Tcl_mem;
    src_origin: Pcl_size_t; dst_origin: Pcl_size_t; region: Pcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueCopyImageToBuffer_fn = function(
    command_queue: Tcl_command_queue; src_image: Tcl_mem; dst_buffer: Tcl_mem;
    src_origin: Pcl_size_t; region: Pcl_size_t; dst_offset: Tcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueCopyBufferToImage_fn = function(
    command_queue: Tcl_command_queue; src_buffer: Tcl_mem; dst_image: Tcl_mem;
    src_offset: Tcl_size_t; dst_origin: Pcl_size_t; region: Pcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueMapImage_fn = function(
    command_queue: Tcl_command_queue; image: Tcl_mem; blocking_map: Tcl_bool;
    map_flags: Tcl_mem_flags; origin: Pcl_size_t; region: Pcl_size_t;
    image_row_pitch: Pcl_size_t; image_slice_pitch: Pcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event;
    errcode_ret: Pcl_int): Pointer; stdcall;

  TclEnqueueMarkerWithWaitList_fn = function(
    command_queue: Tcl_command_queue; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueBarrierWithWaitList_fn = function(
    command_queue: Tcl_command_queue; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclCreateProgramWithBuiltInKernels_fn = function(
    context: Tcl_context; num_devices: Tcl_uint; device_list: Pcl_device_id;
    kernel_names: PAnsiChar; errcode_ret: Pcl_int): Tcl_program; stdcall;

  TclLinkProgram_fn = function(
    context: Tcl_context; num_devices: Tcl_uint; device_list: Pcl_device_id;
    options: PAnsiChar; num_input_programs: Tcl_uint; input_programs: Pcl_program;
    pfn_notify: procedure(program: Tcl_program; user_data: Pointer); stdcall;
    user_data: Pointer; errcode_ret: Pcl_int): Tcl_program; stdcall;

  TclUnloadPlatformCompiler_fn = function(platform: Tcl_platform_id): Tcl_int; stdcall;

  TclGetKernelArgInfo_fn = function(
    kernel: Tcl_kernel; arg_indx: Tcl_uint; param_name: Tcl_kernel_arg_info;
    param_value_size: Tcl_size_t; param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclEnqueueFillBuffer_fn = function(
    command_queue: Tcl_command_queue; buffer: Tcl_mem; pattern: Pointer;
    pattern_size: Tcl_size_t; offset: Tcl_size_t; size: Tcl_size_t;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueFillImage_fn = function(
    command_queue: Tcl_command_queue; image: Tcl_mem; fill_color: Pointer;
    origin: Pcl_size_t; region: Pcl_size_t; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueMigrateMemObjects_fn = function(
    command_queue: Tcl_command_queue; num_mem_objects: Tcl_uint; mem_objects: Pcl_mem;
    flags: Tcl_mem_migration_flags; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclCreateFromGLBuffer_fn = function(
    context: Tcl_context; flags: Tcl_mem_flags; bufobj: Tcl_uint;
    errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclCreateFromGLTexture_fn = function(
    context: Tcl_context; flags: Tcl_mem_flags; texture_target: Tcl_uint;
    miplevel: Tcl_int; texture: Tcl_uint; errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclCreateFromGLRenderbuffer_fn = function(
    context: Tcl_context; flags: Tcl_mem_flags; renderbuffer: Tcl_uint;
    errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclGetGLObjectInfo_fn = function(
    memobj: Tcl_mem; gl_object_type: Pcl_gl_object_type; gl_object_name: Pcl_uint): Tcl_int; stdcall;

  TclGetGLTextureInfo_fn = function(
    memobj: Tcl_mem; param_name: Tcl_gl_texture_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclEnqueueAcquireGLObjects_fn = function(
    command_queue: Tcl_command_queue; num_objects: Tcl_uint; mem_objects: Pcl_mem;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueReleaseGLObjects_fn = function(
    command_queue: Tcl_command_queue; num_objects: Tcl_uint; mem_objects: Pcl_mem;
    num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;
{$ENDIF}

{$IFDEF CL_VERSION_2_0}
  TclCreateCommandQueueWithProperties_fn = function(
    context: Tcl_context; device: Tcl_device_id; properties: Pcl_queue_properties;
    errcode_ret: Pcl_int): Tcl_command_queue; stdcall;

  TclCreatePipe_fn = function(
    context: Tcl_context; flags: Tcl_mem_flags; pipe_packet_size: Tcl_uint;
    pipe_max_packets: Tcl_uint; properties: Pcl_pipe_properties; errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclGetPipeInfo_fn = function(
    pipe: Tcl_mem; param_name: Tcl_pipe_info; param_value_size: Tcl_size_t;
    param_value: Pointer; param_value_size_ret: Pcl_size_t): Tcl_int; stdcall;

  TclSVMAlloc_fn = function(
    context: Tcl_context; flags: Tcl_svm_mem_flags; size: Tcl_size_t;
    alignment: Tcl_uint): Pointer; stdcall;

  TclSVMFree_fn = procedure(
    context: Tcl_context; svm_pointer: Pointer); stdcall;

  TclEnqueueSVMFree_fn = function(
    command_queue: Tcl_command_queue; num_svm_pointers: Tcl_uint; svm_pointers: PPointer;
    pfn_free_func: procedure(queue: Tcl_command_queue; num_svm_pointers: Tcl_uint; svm_pointers: PPointer; user_data: Pointer); stdcall;
    user_data: Pointer; num_events_in_wait_list: Tcl_uint; event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueSVMMemcpy_fn = function(
    command_queue: Tcl_command_queue; blocking_copy: Tcl_bool; dst_ptr: Pointer;
    src_ptr: Pointer; size: Tcl_size_t; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueSVMMemFill_fn = function(
    command_queue: Tcl_command_queue; svm_ptr: Pointer; pattern: Pointer;
    pattern_size: Tcl_size_t; size: Tcl_size_t; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueSVMMap_fn = function(
    command_queue: Tcl_command_queue; blocking_map: Tcl_bool; flags: Tcl_mem_flags;
    svm_ptr: Pointer; size: Tcl_size_t; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclEnqueueSVMUnmap_fn = function(
    command_queue: Tcl_command_queue; svm_ptr: Pointer; num_events_in_wait_list: Tcl_uint;
    event_wait_list: Pcl_event; event: Pcl_event): Tcl_int; stdcall;

  TclSetKernelArgSVMPointer_fn = function(
    kernel: Tcl_kernel; arg_index: Tcl_uint; arg_value: Pointer): Tcl_int; stdcall;

  TclSetKernelExecInfo_fn = function(
    kernel: Tcl_kernel; param_name: Tcl_kernel_exec_info; param_value_size: Tcl_size_t;
    param_value: Pointer): Tcl_int; stdcall;

  TclCreateProgramWithIL_fn = function(
    context: Tcl_context; il: Pointer; length: Tcl_size_t; errcode_ret: Pcl_int): Tcl_program; stdcall;
{$ENDIF}

{$IFDEF CL_VERSION_2_1}
  TclCloneKernel_fn = function(
    source_kernel: Tcl_kernel; errcode_ret: Pcl_int): Tcl_kernel; stdcall;

  TclGetHostTimer_fn = function(
    device: Tcl_device_id; host_timestamp: Pcl_ulong): Tcl_int; stdcall;

  TclGetDeviceAndHostTimer_fn = function(
    device: Tcl_device_id; device_timestamp: Pcl_ulong; host_timestamp: Pcl_ulong): Tcl_int; stdcall;
{$ENDIF}

{$IFDEF CL_VERSION_3_0}
  TclSetDefaultDeviceCommandQueue_fn = function(
    context: Tcl_context; device: Tcl_device_id; command_queue: Tcl_command_queue): Tcl_int; stdcall;

  TclCreateBufferWithProperties_fn = function(
    context: Tcl_context; properties: Pcl_mem_properties; flags: Tcl_mem_flags;
    size: Tcl_size_t; host_ptr: Pointer; errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclCreateImageWithProperties_fn = function(
    context: Tcl_context; properties: Pcl_mem_properties; flags: Tcl_mem_flags;
    image_format: Pcl_image_format; image_desc: Pcl_image_desc; host_ptr: Pointer;
    errcode_ret: Pcl_int): Tcl_mem; stdcall;

  TclUnloadCompiler_fn = function: Tcl_int; stdcall;
{$ENDIF}

const
  ALL_DEVICES: Tcl_size_t = -1;

  PLATFORM_PROFILE = $0900;
  PLATFORM_VERSION = $0901;
  PLATFORM_NAME = $0902;
  PLATFORM_VENDOR = $0903;
  PLATFORM_EXTENSIONS = $0904;
{$IFDEF CL_VERSION_2_1}
  PLATFORM_HOST_TIMER_RESOLUTION = $0905;
{$ENDIF}

  DEVICE_TYPE_DEFAULT = (1 shl 0);
  DEVICE_TYPE_CPU = (1 shl 1);
  DEVICE_TYPE_GPU = (1 shl 2);
  DEVICE_TYPE_ACCELERATOR = (1 shl 3);
  DEVICE_TYPE_CUSTOM = (1 shl 4);
  DEVICE_TYPE_ALL = $FFFFFFFF;

  DEVICE_TYPE = $1000;
  DEVICE_VENDOR_ID = $1001;
  DEVICE_MAX_COMPUTE_UNITS = $1002;
  DEVICE_MAX_WORK_ITEM_DIMENSIONS = $1003;
  DEVICE_MAX_WORK_GROUP_SIZE = $1004;
  DEVICE_MAX_WORK_ITEM_SIZES = $1005;
  DEVICE_PREFERRED_VECTOR_WIDTH_CHAR = $1006;
  DEVICE_PREFERRED_VECTOR_WIDTH_SHORT = $1007;
  DEVICE_PREFERRED_VECTOR_WIDTH_INT = $1008;
  DEVICE_PREFERRED_VECTOR_WIDTH_LONG = $1009;
  DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT = $100A;
  DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE = $100B;
  DEVICE_MAX_CLOCK_FREQUENCY = $100C;
  DEVICE_ADDRESS_BITS = $100D;
  DEVICE_MAX_READ_IMAGE_ARGS = $100E;
  DEVICE_MAX_WRITE_IMAGE_ARGS = $100F;
  DEVICE_MAX_MEM_ALLOC_SIZE = $1010;
  DEVICE_IMAGE2D_MAX_WIDTH = $1011;
  DEVICE_IMAGE2D_MAX_HEIGHT = $1012;
  DEVICE_IMAGE3D_MAX_WIDTH = $1013;
  DEVICE_IMAGE3D_MAX_HEIGHT = $1014;
  DEVICE_IMAGE3D_MAX_DEPTH = $1015;
  DEVICE_IMAGE_SUPPORT = $1016;
  DEVICE_MAX_PARAMETER_SIZE = $1017;
  DEVICE_MAX_SAMPLERS = $1018;
  DEVICE_MEM_BASE_ADDR_ALIGN = $1019;
  DEVICE_MIN_DATA_TYPE_ALIGN_SIZE = $101A;
  DEVICE_SINGLE_FP_CONFIG = $101B;
  DEVICE_GLOBAL_MEM_CACHE_TYPE = $101C;
  DEVICE_GLOBAL_MEM_CACHELINE_SIZE = $101D;
  DEVICE_GLOBAL_MEM_CACHE_SIZE = $101E;
  DEVICE_GLOBAL_MEM_SIZE = $101F;
  DEVICE_MAX_CONSTANT_BUFFER_SIZE = $1020;
  DEVICE_MAX_CONSTANT_ARGS = $1021;
  DEVICE_LOCAL_MEM_TYPE = $1022;
  DEVICE_LOCAL_MEM_SIZE = $1023;
  DEVICE_ERROR_CORRECTION_SUPPORT = $1024;
  DEVICE_PROFILING_TIMER_RESOLUTION = $1025;
  DEVICE_ENDIAN_LITTLE = $1026;
  DEVICE_AVAILABLE = $1027;
  DEVICE_COMPILER_AVAILABLE = $1028;
  DEVICE_EXECUTION_CAPABILITIES = $1029;
  DEVICE_QUEUE_PROPERTIES = $102A;
{$IFDEF CL_VERSION_2_0}
  DEVICE_QUEUE_ON_HOST_PROPERTIES = $102A;
{$ENDIF}
  DEVICE_NAME = $102B;
  DEVICE_VENDOR = $102C;
  DEVICE_DRIVER_VERSION = $102D;
  DEVICE_PROFILE = $102E;
  DEVICE_VERSION = $102F;
  DEVICE_EXTENSIONS = $1030;
  DEVICE_PLATFORM = $1031;
{$IFDEF CL_VERSION_1_1}
  DEVICE_PREFERRED_VECTOR_WIDTH_HALF = $1034;
  DEVICE_HOST_UNIFIED_MEMORY = $1035;
  DEVICE_NATIVE_VECTOR_WIDTH_CHAR = $1036;
  DEVICE_NATIVE_VECTOR_WIDTH_SHORT = $1037;
  DEVICE_NATIVE_VECTOR_WIDTH_INT = $1038;
  DEVICE_NATIVE_VECTOR_WIDTH_LONG = $1039;
  DEVICE_NATIVE_VECTOR_WIDTH_FLOAT = $103A;
  DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE = $103B;
  DEVICE_NATIVE_VECTOR_WIDTH_HALF = $103C;
  DEVICE_OPENCL_C_VERSION = $103D;
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  DEVICE_LINKER_AVAILABLE = $103E;
  DEVICE_BUILT_IN_KERNELS = $103F;
  DEVICE_IMAGE_MAX_BUFFER_SIZE = $1040;
  DEVICE_IMAGE_MAX_ARRAY_SIZE = $1041;
  DEVICE_PARENT_DEVICE = $1042;
  DEVICE_PARTITION_MAX_SUB_DEVICES = $1043;
  DEVICE_PARTITION_PROPERTIES = $1044;
  DEVICE_PARTITION_AFFINITY_DOMAIN = $1045;
  DEVICE_PARTITION_TYPE = $1046;
  DEVICE_REFERENCE_COUNT = $1047;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  DEVICE_QUEUE_ON_DEVICE_PROPERTIES = $104A;
  DEVICE_QUEUE_ON_DEVICE_PREFERRED_SIZE = $104B;
  DEVICE_QUEUE_ON_DEVICE_MAX_SIZE = $104C;
  DEVICE_MAX_ON_DEVICE_QUEUES = $104D;
  DEVICE_MAX_ON_DEVICE_EVENTS = $104E;
  DEVICE_SVM_CAPABILITIES = $104F;
  DEVICE_GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE = $1050;
  DEVICE_MAX_PIPE_ARGS = $1051;
  DEVICE_PIPE_MAX_ACTIVE_RESERVATIONS = $1052;
  DEVICE_PIPE_MAX_PACKET_SIZE = $1053;
  DEVICE_PREFERRED_PLATFORM_ATOMIC_ALIGNMENT = $1054;
  DEVICE_PREFERRED_GLOBAL_ATOMIC_ALIGNMENT = $1055;
  DEVICE_PREFERRED_LOCAL_ATOMIC_ALIGNMENT = $1056;
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  DEVICE_IL_VERSION = $105B;
  DEVICE_MAX_NUM_SUB_GROUPS = $105C;
  DEVICE_SUB_GROUP_INDEPENDENT_FORWARD_PROGRESS = $105D;
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  DEVICE_NUMERIC_VERSION = $105E;
  DEVICE_EXTENSIONS_WITH_VERSION = $105F;
  DEVICE_ILS_WITH_VERSION = $1060;
  DEVICE_BUILT_IN_KERNELS_WITH_VERSION = $1061;
  DEVICE_ATOMIC_MEMORY_CAPABILITIES = $1062;
  DEVICE_ATOMIC_FENCE_CAPABILITIES = $1063;
  DEVICE_NON_UNIFORM_WORK_GROUP_SUPPORT = $1064;
  DEVICE_OPENCL_C_ALL_VERSIONS = $1065;
  DEVICE_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = $1066;
  DEVICE_WORK_GROUP_COLLECTIVE_FUNCTIONS_SUPPORT = $1067;
  DEVICE_GENERIC_ADDRESS_SPACE_SUPPORT = $1068;
  DEVICE_OPENCL_C_FEATURES = $106F;
  DEVICE_DEVICE_ENQUEUE_CAPABILITIES = $1070;
  DEVICE_PIPE_SUPPORT = $1071;
  DEVICE_LATEST_CONFORMANCE_VERSION_PASSED = $1072;
{$ENDIF}

  CONTEXT_PLATFORM = $1084;
{$IFDEF CL_VERSION_1_1}
  CONTEXT_INTEROP_USER_SYNC = $1085;
{$ENDIF}

  CONTEXT_REFERENCE_COUNT = $1080;
  CONTEXT_DEVICES = $1081;
  CONTEXT_PROPERTIES = $1082;
{$IFDEF CL_VERSION_1_1}
  CONTEXT_NUM_DEVICES = $1083;
{$ENDIF}

  QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 shl 0);
  QUEUE_PROFILING_ENABLE = (1 shl 1);
{$IFDEF CL_VERSION_2_0}
  QUEUE_ON_DEVICE = (1 shl 2);
  QUEUE_ON_DEVICE_DEFAULT = (1 shl 3);
{$ENDIF}

  QUEUE_CONTEXT = $1090;
  QUEUE_DEVICE = $1091;
  QUEUE_REFERENCE_COUNT = $1092;
  QUEUE_PROPERTIES = $1093;
{$IFDEF CL_VERSION_2_0}
  QUEUE_SIZE = $1094;
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  QUEUE_DEVICE_DEFAULT = $1095;
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  QUEUE_PROPERTIES_ARRAY = $1098;
{$ENDIF}

  MEM_READ_WRITE = (1 shl 0);
  MEM_WRITE_ONLY = (1 shl 1);
  MEM_READ_ONLY = (1 shl 2);
  MEM_USE_HOST_PTR = (1 shl 3);
  MEM_ALLOC_HOST_PTR = (1 shl 4);
  MEM_COPY_HOST_PTR = (1 shl 5);
{$IFDEF CL_VERSION_1_2}
  MEM_HOST_WRITE_ONLY = (1 shl 7);
  MEM_HOST_READ_ONLY = (1 shl 8);
  MEM_HOST_NO_ACCESS = (1 shl 9);
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  MEM_KERNEL_READ_AND_WRITE = (1 shl 10);
{$ENDIF}

  MEM_TYPE = $1100;
  MEM_FLAGS = $1101;
  MEM_SIZE = $1102;
  MEM_HOST_PTR = $1103;
  MEM_MAP_COUNT = $1104;
  MEM_REFERENCE_COUNT = $1105;
  MEM_CONTEXT = $1106;
{$IFDEF CL_VERSION_1_1}
  MEM_ASSOCIATED_MEMOBJECT = $1107;
  MEM_OFFSET = $1108;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  MEM_USES_SVM_POINTER = $1109;
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  MEM_PROPERTIES = $110A;
{$ENDIF}

  PROGRAM_REFERENCE_COUNT = $1160;
  PROGRAM_CONTEXT = $1161;
  PROGRAM_NUM_DEVICES = $1162;
  PROGRAM_DEVICES = $1163;
  PROGRAM_SOURCE = $1164;
  PROGRAM_BINARY_SIZES = $1165;
  PROGRAM_BINARIES = $1166;
{$IFDEF CL_VERSION_1_2}
  PROGRAM_NUM_KERNELS = $1167;
  PROGRAM_KERNEL_NAMES = $1168;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  PROGRAM_IL = $1169;
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  PROGRAM_SCOPE_GLOBAL_CTORS_PRESENT = $116A;
  PROGRAM_SCOPE_GLOBAL_DTORS_PRESENT = $116B;
{$ENDIF}

  CL_BUILD_SUCCESS = 0;
  CL_BUILD_NONE = -1;
  CL_BUILD_ERROR = -2;
  CL_BUILD_IN_PROGRESS = -3;

  PROGRAM_BUILD_STATUS = $1181;
  PROGRAM_BUILD_OPTIONS = $1182;
  PROGRAM_BUILD_LOG = $1183;
{$IFDEF CL_VERSION_2_0}
  PROGRAM_BINARY_TYPE = $1184;
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE = $1185;
{$ENDIF}

{$IFDEF CL_VERSION_2_0}
  PROGRAM_BINARY_TYPE_NONE = $0;
  PROGRAM_BINARY_TYPE_COMPILED_OBJECT = $1;
  PROGRAM_BINARY_TYPE_LIBRARY = $2;
  PROGRAM_BINARY_TYPE_EXECUTABLE = $4;
{$ENDIF}

  KERNEL_FUNCTION_NAME = $1190;
  KERNEL_NUM_ARGS = $1191;
  KERNEL_REFERENCE_COUNT = $1192;
  KERNEL_CONTEXT = $1193;
  KERNEL_PROGRAM = $1194;
{$IFDEF CL_VERSION_1_2}
  KERNEL_ATTRIBUTES = $1195;
{$ENDIF}

{$IFDEF CL_VERSION_1_1}
  KERNEL_WORK_GROUP_SIZE = $11B0;
  KERNEL_COMPILE_WORK_GROUP_SIZE = $11B1;
  KERNEL_LOCAL_MEM_SIZE = $11B2;
  KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = $11B3;
  KERNEL_PRIVATE_MEM_SIZE = $11B4;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  KERNEL_MAX_SUB_GROUP_SIZE_FOR_NDRANGE = $2033;
  KERNEL_SUB_GROUP_COUNT_FOR_NDRANGE = $2034;
{$ENDIF}

{$IFDEF CL_VERSION_1_2}
  KERNEL_ARG_ADDRESS_QUALIFIER = $1196;
  KERNEL_ARG_ACCESS_QUALIFIER = $1197;
  KERNEL_ARG_TYPE_NAME = $1198;
  KERNEL_ARG_TYPE_QUALIFIER = $1199;
  KERNEL_ARG_NAME = $119A;
{$ENDIF}

{$IFDEF CL_VERSION_1_2}
  KERNEL_ARG_ADDRESS_GLOBAL = $119B;
  KERNEL_ARG_ADDRESS_LOCAL = $119C;
  KERNEL_ARG_ADDRESS_CONSTANT = $119D;
  KERNEL_ARG_ADDRESS_PRIVATE = $119E;

  KERNEL_ARG_ACCESS_READ_ONLY = $11A0;
  KERNEL_ARG_ACCESS_WRITE_ONLY = $11A1;
  KERNEL_ARG_ACCESS_READ_WRITE = $11A2;
  KERNEL_ARG_ACCESS_NONE = $11A3;

  KERNEL_ARG_TYPE_NONE = 0;
  KERNEL_ARG_TYPE_CONST = (1 shl 0);
  KERNEL_ARG_TYPE_RESTRICT = (1 shl 1);
  KERNEL_ARG_TYPE_VOLATILE = (1 shl 2);
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  KERNEL_ARG_TYPE_PIPE = (1 shl 3);
{$ENDIF}

  EVENT_COMMAND_QUEUE = $11D0;
  EVENT_COMMAND_TYPE = $11D1;
  EVENT_REFERENCE_COUNT = $11D2;
  EVENT_COMMAND_EXECUTION_STATUS = $11D3;
  EVENT_CONTEXT = $11D4;
{$IFDEF CL_VERSION_2_1}
  EVENT_COMMAND_START = $11D5;
  EVENT_COMMAND_END = $11D6;
{$ENDIF}

  COMPLETE = $0;
  RUNNING = $1;
  SUBMITTED = $2;
  QUEUED = $3;

{$IFDEF CL_VERSION_1_1}
  COMMAND_COMPLETE = $0;
{$ENDIF}

  SAMPLER_REFERENCE_COUNT = $1150;
  SAMPLER_CONTEXT = $1151;
  SAMPLER_NORMALIZED_COORDS = $1152;
  SAMPLER_ADDRESSING_MODE = $1153;
  SAMPLER_FILTER_MODE = $1154;
{$IFDEF CL_VERSION_2_0}
  SAMPLER_MIP_FILTER_MODE = $1155;
  SAMPLER_LOD_MIN = $1156;
  SAMPLER_LOD_MAX = $1157;
{$ENDIF}

  ADDRESS_NONE = $1130;
  ADDRESS_CLAMP_TO_EDGE = $1131;
  ADDRESS_CLAMP = $1132;
  ADDRESS_REPEAT = $1133;
{$IFDEF CL_VERSION_1_1}
  ADDRESS_MIRRORED_REPEAT = $1134;
{$ENDIF}

  FILTER_NEAREST = $1140;
  FILTER_LINEAR = $1141;

  COMMAND_NDRANGE_KERNEL = $11F0;
  COMMAND_TASK = $11F1;
  COMMAND_NATIVE_KERNEL = $11F2;
  COMMAND_READ_BUFFER = $11F3;
  COMMAND_WRITE_BUFFER = $11F4;
  COMMAND_COPY_BUFFER = $11F5;
  COMMAND_READ_IMAGE = $11F6;
  COMMAND_WRITE_IMAGE = $11F7;
  COMMAND_COPY_IMAGE = $11F8;
  COMMAND_COPY_IMAGE_TO_BUFFER = $11F9;
  COMMAND_COPY_BUFFER_TO_IMAGE = $11FA;
  COMMAND_MAP_BUFFER = $11FB;
  COMMAND_MAP_IMAGE = $11FC;
  COMMAND_UNMAP_MEM_OBJECT = $11FD;
  COMMAND_MARKER = $11FE;
  COMMAND_ACQUIRE_GL_OBJECTS = $11FF;
  COMMAND_RELEASE_GL_OBJECTS = $1200;
{$IFDEF CL_VERSION_1_1}
  COMMAND_READ_BUFFER_RECT = $1201;
  COMMAND_WRITE_BUFFER_RECT = $1202;
  COMMAND_COPY_BUFFER_RECT = $1203;
  COMMAND_USER = $1204;
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  COMMAND_BARRIER = $1205;
  COMMAND_MIGRATE_MEM_OBJECTS = $1206;
  COMMAND_FILL_BUFFER = $1207;
  COMMAND_FILL_IMAGE = $1208;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  COMMAND_SVM_FREE = $1209;
  COMMAND_SVM_MEMCPY = $120A;
  COMMAND_SVM_MEMFILL = $120B;
  COMMAND_SVM_MAP = $120C;
  COMMAND_SVM_UNMAP = $120D;
{$ENDIF}

{$IFDEF CL_VERSION_1_1}
  BUFFER_CREATE_TYPE_REGION = $1220;
{$ENDIF}

const
  MEM_OBJECT_BUFFER = $10F0;
  MEM_OBJECT_IMAGE2D = $10F1;
  MEM_OBJECT_IMAGE3D = $10F2;
{$IFDEF CL_VERSION_1_2}
  MEM_OBJECT_IMAGE2D_ARRAY = $10F3;
  MEM_OBJECT_IMAGE1D = $10F4;
  MEM_OBJECT_IMAGE1D_ARRAY = $10F5;
  MEM_OBJECT_IMAGE1D_BUFFER = $10F6;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  MEM_OBJECT_PIPE = $10F7;
{$ENDIF}

  CL_R = $10B0;
  CL_A = $10B1;
  CL_RG = $10B2;
  CL_RA = $10B3;
  CL_RGB = $10B4;
  CL_RGBA = $10B5;
  CL_BGRA = $10B6;
  CL_ARGB = $10B7;
  CL_INTENSITY = $10B8;
  CL_LUMINANCE = $10B9;
{$IFDEF CL_VERSION_1_1}
  CL_Rx = $10BA;
  CL_RGx = $10BB;
  CL_RGBx = $10BC;
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  CL_DEPTH = $10BD;
  CL_DEPTH_STENCIL = $10BE;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  CL_sRGB = $10BF;
  CL_sRGBx = $10C0;
  CL_sRGBA = $10C1;
  CL_sBGRA = $10C2;
  CL_ABGR = $10C3;
{$ENDIF}

  CL_SNORM_INT8 = $10D0;
  CL_SNORM_INT16 = $10D1;
  CL_UNORM_INT8 = $10D2;
  CL_UNORM_INT16 = $10D3;
  CL_UNORM_SHORT_565 = $10D4;
  CL_UNORM_SHORT_555 = $10D5;
  CL_UNORM_INT_101010 = $10D6;
  CL_SIGNED_INT8 = $10D7;
  CL_SIGNED_INT16 = $10D8;
  CL_SIGNED_INT32 = $10D9;
  CL_UNSIGNED_INT8 = $10DA;
  CL_UNSIGNED_INT16 = $10DB;
  CL_UNSIGNED_INT32 = $10DC;
  CL_HALF_FLOAT = $10DD;
  CL_FLOAT = $10DE;
{$IFDEF CL_VERSION_1_2}
  CL_UNORM_INT24 = $10DF;
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  CL_UNORM_INT_101010_2 = $10E0;
{$ENDIF}

  FP_DENORM = (1 shl 0);
  FP_INF_NAN = (1 shl 1);
  FP_ROUND_TO_NEAREST = (1 shl 2);
  FP_ROUND_TO_ZERO = (1 shl 3);
  FP_ROUND_TO_INF = (1 shl 4);
  FP_FMA = (1 shl 5);
{$IFDEF CL_VERSION_1_1}
  FP_SOFT_FLOAT = (1 shl 6);
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  FP_CORRECTLY_ROUNDED_DIVIDE_SQRT = (1 shl 7);
{$ENDIF}

  NONE = $0;
  READ_ONLY_CACHE = $1;
  READ_WRITE_CACHE = $2;

  LOCAL = $1;
  GLOBAL = $2;

  EXEC_KERNEL = (1 shl 0);
  EXEC_NATIVE_KERNEL = (1 shl 1);

{$IFDEF CL_VERSION_1_2}
  DEVICE_PARTITION_EQUALLY = $1086;
  DEVICE_PARTITION_BY_COUNTS = $1087;
  DEVICE_PARTITION_BY_AFFINITY_DOMAIN = $1088;

  DEVICE_AFFINITY_DOMAIN_NUMA = (1 shl 0);
  DEVICE_AFFINITY_DOMAIN_L4_CACHE = (1 shl 1);
  DEVICE_AFFINITY_DOMAIN_L3_CACHE = (1 shl 2);
  DEVICE_AFFINITY_DOMAIN_L2_CACHE = (1 shl 3);
  DEVICE_AFFINITY_DOMAIN_L1_CACHE = (1 shl 4);
  DEVICE_AFFINITY_DOMAIN_NEXT_PARTITIONABLE = (1 shl 5);
{$ENDIF}

{$IFDEF CL_VERSION_1_2}
  GL_OBJECT_BUFFER = $2000;
  GL_OBJECT_TEXTURE2D = $2001;
  GL_OBJECT_TEXTURE3D = $2002;
  GL_OBJECT_RENDERBUFFER = $2003;
  GL_OBJECT_TEXTURE2D_ARRAY = $2004;
  GL_OBJECT_TEXTURE1D = $2005;
  GL_OBJECT_TEXTURE1D_ARRAY = $2006;
  GL_OBJECT_TEXTURE_BUFFER = $2007;

  GL_TEXTURE_TARGET = $2008;
  GL_MIPMAP_LEVEL = $2009;
  GL_NUM_SAMPLES = $2010;
{$ENDIF}

{$IFDEF CL_VERSION_2_0}
  SVM_COARSE_GRAIN_BUFFER = (1 shl 0);
  SVM_FINE_GRAIN_BUFFER = (1 shl 1);
  SVM_FINE_GRAIN_SYSTEM = (1 shl 2);
  SVM_ATOMICS = (1 shl 3);
{$ENDIF}

{$IFDEF CL_VERSION_1_2}
  MEM_MIGRATION_FLAGS_HOST = (1 shl 0);
{$ENDIF}

{$IFDEF CL_VERSION_2_0}
  PIPE_PACKET_SIZE = $1120;
  PIPE_MAX_PACKETS = $1121;
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  PIPE_PROPERTIES = $1122;
{$ENDIF}

{$IFDEF CL_VERSION_2_0}
  KERNEL_EXEC_INFO_SVM_PTRS = $11B6;
  KERNEL_EXEC_INFO_SVM_FINE_GRAIN_SYSTEM = $11B7;
{$ENDIF}

{$IFDEF CL_VERSION_2_0}
  COMMAND_SVM_FREE_EVENT = $120E;
{$ENDIF}

type
  TCLPlatform = class
  public
    constructor Create; overload;
    constructor Create(platform: Tcl_platform_id); overload;
    constructor Create(const platform: TCLPlatform); overload;
    destructor Destroy; override;

    function Assign(const rhs: TCLPlatform): TCLPlatform;
    function GetInfo(name: Tcl_platform_info; param: PString): Tcl_int;
    function GetDevices(device_type: Tcl_device_type; devices: PArray<TCLDevice>): Tcl_int;
    function Get: Tcl_platform_id;

    function IsEqual(const rhs: TCLPlatform): Boolean;
    function IsNotEqual(const rhs: TCLPlatform): Boolean;

    class function Get(platforms: PArray<TCLPlatform>): Tcl_int; static;

  private
    FPlatform: Tcl_platform_id;
  end;

  TCLDevice = class
  public
    constructor Create; overload;
    constructor Create(device: Tcl_device_id); overload;
    constructor Create(const device: TCLDevice); overload;
    destructor Destroy; override;

    function Assign(const rhs: TCLDevice): TCLDevice;
    function GetInfo(name: Tcl_device_info; param: PString): Tcl_int;
    function Get: Tcl_device_id;
    function GetPlatform(platform: TCLPlatform): Tcl_int;

  private
    FDevice: Tcl_device_id;
  end;

  TCLContext = class
  public
    constructor Create; overload;
    constructor Create(const properties: array of Tcl_context_properties; num_devices: Tcl_uint; devices: Pcl_device_id;
      pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall; user_data: Pointer); overload;
    constructor Create(device_type: Tcl_device_type; pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall; user_data: Pointer); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_context_info; param_value: PString): Tcl_int;
    function Get: Tcl_context;

  private
    FContext: Tcl_context;
  end;

  TCLCommandQueue = class
  public
    constructor Create; overload;
    constructor Create(context: TCLContext; device: TCLDevice; properties: Tcl_queue_properties); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_command_queue_info; param_value: PString): Tcl_int;
    function Get: Tcl_command_queue;
    function Finish: Tcl_int;
    function Flush: Tcl_int;

  private
    FQueue: Tcl_command_queue;
  end;

  TCLProgram = class
  public
    constructor Create; overload;
    constructor Create(context: TCLContext; count: Tcl_uint; strings: PPAnsiChar; lengths: Pcl_size_t); overload;
    constructor Create(context: TCLContext; devices: PArray<TCLDevice>; lengths: Pcl_size_t; binaries: PPcl_uchar; binary_status: Pcl_int); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_program_info; param_value: PString): Tcl_int;
    function GetBuildInfo(device: TCLDevice; param_name: Tcl_program_build_info; param_value: PString): Tcl_int;
    function Build(devices: PArray<TCLDevice>; options: PAnsiChar; pfn_notify: procedure(program: Tcl_program; user_data: Pointer); stdcall; user_data: Pointer): Tcl_int;
    function Get: Tcl_program;

  private
    FProgram: Tcl_program;
  end;

  TCLKernel = class
  public
    constructor Create; overload;
    constructor Create(program: TCLProgram; kernel_name: PAnsiChar); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_kernel_info; param_value: PString): Tcl_int;
    function SetArg(arg_index: Tcl_uint; arg_size: Tcl_size_t; arg_value: Pointer): Tcl_int;
    function Get: Tcl_kernel;

  private
    FKernel: Tcl_kernel;
  end;

  TCLMemory = class
  public
    constructor Create; overload;
    constructor Create(context: TCLContext; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_mem_info; param_value: PString): Tcl_int;
    function Get: Tcl_mem;

  private
    FMemory: Tcl_mem;
  end;

  TCLBuffer = class(TCLMemory)
  public
    constructor Create; overload;
    constructor Create(context: TCLContext; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer); overload;
    destructor Destroy; override;
  end;

  TCLEvent = class
  public
    constructor Create; overload;
    constructor Create(context: TCLContext); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_event_info; param_value: PString): Tcl_int;
    function Get: Tcl_event;
    function Wait: Tcl_int;

  private
    FEvent: Tcl_event;
  end;

  TCLSampler = class
  public
    constructor Create; overload;
    constructor Create(context: TCLContext; normalized_coords: Tcl_bool; addressing_mode: Tcl_addressing_mode; filter_mode: Tcl_filter_mode); overload;
    destructor Destroy; override;

    function GetInfo(param_name: Tcl_sampler_info; param_value: PString): Tcl_int;
    function Get: Tcl_sampler;

  private
    FSampler: Tcl_sampler;
  end;

function GetPlatforms(platforms: PArray<TCLPlatform>): Tcl_int;
function GetDevices(const platform: TCLPlatform; device_type: Tcl_device_type; devices: PArray<TCLDevice>): Tcl_int;

const
  EXTENSION_SUFFIX = '_cl_khr';
  EXTENSION_LIST: array[0..7] of PAnsiChar = (
    'cl_khr_fp64',
    'cl_khr_fp16',
    'cl_khr_gl_sharing',
    'cl_khr_gl_event',
    'cl_khr_d3d10_sharing',
    'cl_khr_d3d11_sharing',
    'cl_khr_dx9_media_sharing',
    nil
  );

// Nova classe wrapper TOpenCLWrapper
type
  TOpenCLWrapper = class
  private
    FPlatform: TCLPlatform;
    FDevice: TCLDevice;
    FContext: TCLContext;
    FCommandQueue: TCLCommandQueue;
    FProgram: TCLProgram;
    FKernel: TCLKernel;
    FBuffer: TCLBuffer;
    FEvent: TCLEvent;
    FSampler: TCLSampler;
    FPlatforms: TArray<TCLPlatform>;
    FDevices: TArray<TCLDevice>;

    function GetPlatform: TCLPlatform;
    function GetDevice: TCLDevice;
    function GetContext: TCLContext;
    function GetCommandQueue: TCLCommandQueue;
    function GetProgram: TCLProgram;
    function GetKernel: TCLKernel;
    function GetBuffer: TCLBuffer;
    function GetEvent: TCLEvent;
    function GetSampler: TCLSampler;

  public
    constructor Create;
    destructor Destroy; override;

    // Métodos para inicialização
    procedure InitializePlatform(index: Integer = 0);
    procedure InitializeDevice(index: Integer = 0; deviceType: Tcl_device_type = DEVICE_TYPE_DEFAULT);
    procedure InitializeContext;
    procedure InitializeCommandQueue(properties: Tcl_queue_properties = 0);
    procedure InitializeProgramFromSource(const source: string);
    procedure InitializeKernel(const kernelName: string);
    procedure InitializeBuffer(size: Tcl_size_t; flags: Tcl_mem_flags = MEM_READ_WRITE; hostPtr: Pointer = nil);

    // Métodos para execução
    procedure SetKernelArg(argIndex: Tcl_uint; argSize: Tcl_size_t; argValue: Pointer);
    procedure EnqueueNDRangeKernel(workDim: Tcl_uint; globalWorkSize, localWorkSize: Pcl_size_t; event: TCLEvent = nil);
    procedure EnqueueReadBuffer(buffer: TCLBuffer; size: Tcl_size_t; ptr: Pointer; offset: Tcl_size_t = 0; blocking: Boolean = True; event: TCLEvent = nil);
    procedure EnqueueWriteBuffer(buffer: TCLBuffer; size: Tcl_size_t; ptr: Pointer; offset: Tcl_size_t = 0; blocking: Boolean = True; event: TCLEvent = nil);
    procedure Finish;

    // Propriedades para acesso às instâncias
    property Platform: TCLPlatform read GetPlatform;
    property Device: TCLDevice read GetDevice;
    property Context: TCLContext read GetContext;
    property CommandQueue: TCLCommandQueue read GetCommandQueue;
    property Program: TCLProgram read GetProgram;
    property Kernel: TCLKernel read GetKernel;
    property Buffer: TCLBuffer read GetBuffer;
    property Event: TCLEvent read GetEvent;
    property Sampler: TCLSampler read GetSampler;
    property Platforms: TArray<TCLPlatform> read FPlatforms;
    property Devices: TArray<TCLDevice> read FDevices;
  end;

implementation

{$IFDEF CL_HPP_ENABLE_EXCEPTIONS}
constructor TCLError.Create(err: Tcl_int; errStr: PAnsiChar);
begin
  FErr := err;
  if errStr = nil then
    FErrStr := 'empty'
  else
    FErrStr := string(errStr);
  inherited Create(FErrStr);
end;

function TCLError.Err: Tcl_int;
begin
  Result := FErr;
end;
{$ENDIF}

{$IFNDEF CL_HPP_USER_OVERRIDE_ERROR_STRINGS}
function ErrorString(error: Tcl_int): string;
begin
  case error of
    CL_SUCCESS: Result := 'Success';
    CL_DEVICE_NOT_FOUND: Result := 'Device Not Found';
    CL_DEVICE_NOT_AVAILABLE: Result := 'Device Not Available';
    CL_COMPILER_NOT_AVAILABLE: Result := 'Compiler Not Available';
    CL_MEM_OBJECT_ALLOCATION_FAILURE: Result := 'Memory Object Allocation Failure';
    CL_OUT_OF_RESOURCES: Result := 'Out of Resources';
    CL_OUT_OF_HOST_MEMORY: Result := 'Out of Host Memory';
    CL_PROFILING_INFO_NOT_AVAILABLE: Result := 'Profiling Information Not Available';
    CL_MEM_COPY_OVERLAP: Result := 'Memory Copy Overlap';
    CL_IMAGE_FORMAT_MISMATCH: Result := 'Image Format Mismatch';
    CL_IMAGE_FORMAT_NOT_SUPPORTED: Result := 'Image Format Not Supported';
    CL_BUILD_PROGRAM_FAILURE: Result := 'Build Program Failure';
    CL_MAP_FAILURE: Result := 'Map Failure';
    CL_MISALIGNED_SUB_BUFFER_OFFSET: Result := 'Misaligned Sub-Buffer Offset';
    CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST: Result := 'Execution Status Error for Events in Wait List';
    CL_INVALID_VALUE: Result := 'Invalid Value';
    CL_INVALID_DEVICE_TYPE: Result := 'Invalid Device Type';
    CL_INVALID_PLATFORM: Result := 'Invalid Platform';
    CL_INVALID_DEVICE: Result := 'Invalid Device';
    CL_INVALID_CONTEXT: Result := 'Invalid Context';
    CL_INVALID_QUEUE_PROPERTIES: Result := 'Invalid Queue Properties';
    CL_INVALID_COMMAND_QUEUE: Result := 'Invalid Command Queue';
    CL_INVALID_HOST_PTR: Result := 'Invalid Host Pointer';
    CL_INVALID_MEM_OBJECT: Result := 'Invalid Memory Object';
    CL_INVALID_IMAGE_FORMAT_DESCRIPTOR: Result := 'Invalid Image Format Descriptor';
    CL_INVALID_IMAGE_SIZE: Result := 'Invalid Image Size';
    CL_INVALID_SAMPLER: Result := 'Invalid Sampler';
    CL_INVALID_BINARY: Result := 'Invalid Binary';
    CL_INVALID_BUILD_OPTIONS: Result := 'Invalid Build Options';
    CL_INVALID_PROGRAM: Result := 'Invalid Program';
    CL_INVALID_PROGRAM_EXECUTABLE: Result := 'Invalid Program Executable';
    CL_INVALID_KERNEL_NAME: Result := 'Invalid Kernel Name';
    CL_INVALID_KERNEL_DEFINITION: Result := 'Invalid Kernel Definition';
    CL_INVALID_KERNEL: Result := 'Invalid Kernel';
    CL_INVALID_ARG_INDEX: Result := 'Invalid Argument Index';
    CL_INVALID_ARG_VALUE: Result := 'Invalid Argument Value';
    CL_INVALID_ARG_SIZE: Result := 'Invalid Argument Size';
    CL_INVALID_KERNEL_ARGS: Result := 'Invalid Kernel Arguments';
    CL_INVALID_WORK_DIMENSION: Result := 'Invalid Work Dimension';
    CL_INVALID_WORK_GROUP_SIZE: Result := 'Invalid Work Group Size';
    CL_INVALID_WORK_ITEM_SIZE: Result := 'Invalid Work Item Size';
    CL_INVALID_GLOBAL_OFFSET: Result := 'Invalid Global Offset';
    CL_INVALID_EVENT_WAIT_LIST: Result := 'Invalid Event Wait List';
    CL_INVALID_EVENT: Result := 'Invalid Event';
    CL_INVALID_OPERATION: Result := 'Invalid Operation';
    CL_INVALID_GL_OBJECT: Result := 'Invalid GL Object';
    CL_INVALID_BUFFER_SIZE: Result := 'Invalid Buffer Size';
    CL_INVALID_MIP_LEVEL: Result := 'Invalid MIP Level';
    CL_INVALID_GLOBAL_WORK_SIZE: Result := 'Invalid Global Work Size';
    CL_INVALID_PROPERTY: Result := 'Invalid Property';
    else Result := 'Unknown Error';
  end;
end;
{$ENDIF}

{$IFDEF CL_HPP_ENABLE_EXCEPTIONS}
procedure ErrChk(err: Tcl_int; operation: PAnsiChar);
begin
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, operation);
end;
{$ENDIF}

constructor TCLPlatform.Create;
begin
  FPlatform := nil;
end;

constructor TCLPlatform.Create(platform: Tcl_platform_id);
begin
  FPlatform := platform;
end;

constructor TCLPlatform.Create(const platform: TCLPlatform);
begin
  FPlatform := platform.FPlatform;
end;

destructor TCLPlatform.Destroy;
begin
  inherited;
end;

function TCLPlatform.Assign(const rhs: TCLPlatform): TCLPlatform;
begin
  FPlatform := rhs.FPlatform;
  Result := Self;
end;

function TCLPlatform.GetInfo(name: Tcl_platform_info; param: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetPlatformInfo(FPlatform, name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param <> nil then param^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetPlatformInfo(FPlatform, name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param <> nil then
    param^ := string(PAnsiChar(@param_data[0]));
end;

function TCLPlatform.GetDevices(device_type: Tcl_device_type; devices: PArray<TCLDevice>): Tcl_int;
var
  num_devices: Tcl_uint;
  device_ids: TArray<Tcl_device_id>;
  i: Integer;
begin
  num_devices := 0;
  Result := clGetDeviceIDs(FPlatform, device_type, 0, nil, @num_devices);
  if (Result <> CL_SUCCESS) or (num_devices = 0) then Exit;
  SetLength(device_ids, num_devices);
  Result := clGetDeviceIDs(FPlatform, device_type, num_devices, @device_ids[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if devices <> nil then
  begin
    SetLength(devices^, num_devices);
    for i := 0 to num_devices - 1 do
      devices^[i] := TCLDevice.Create(device_ids[i]);
  end;
end;

function TCLPlatform.Get: Tcl_platform_id;
begin
  Result := FPlatform;
end;

function TCLPlatform.IsEqual(const rhs: TCLPlatform): Boolean;
begin
  Result := FPlatform = rhs.FPlatform;
end;

function TCLPlatform.IsNotEqual(const rhs: TCLPlatform): Boolean;
begin
  Result := not IsEqual(rhs);
end;

class function TCLPlatform.Get(platforms: PArray<TCLPlatform>): Tcl_int;
var
  num_platforms: Tcl_uint;
  platform_ids: TArray<Tcl_platform_id>;
  i: Integer;
begin
  num_platforms := 0;
  Result := clGetPlatformIDs(0, nil, @num_platforms);
  if (Result <> CL_SUCCESS) or (num_platforms = 0) then Exit;
  SetLength(platform_ids, num_platforms);
  Result := clGetPlatformIDs(num_platforms, @platform_ids[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if platforms <> nil then
  begin
    SetLength(platforms^, num_platforms);
    for i := 0 to num_platforms - 1 do
      platforms^[i] := TCLPlatform.Create(platform_ids[i]);
  end;
end;

constructor TCLDevice.Create;
begin
  FDevice := nil;
end;

constructor TCLDevice.Create(device: Tcl_device_id);
begin
  FDevice := device;
end;

constructor TCLDevice.Create(const device: TCLDevice);
begin
  FDevice := device.FDevice;
end;

destructor TCLDevice.Destroy;
begin
  inherited;
end;

function TCLDevice.Assign(const rhs: TCLDevice): TCLDevice;
begin
  FDevice := rhs.FDevice;
  Result := Self;
end;

function TCLDevice.GetInfo(name: Tcl_device_info; param: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetDeviceInfo(FDevice, name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param <> nil then param^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetDeviceInfo(FDevice, name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param <> nil then
    param^ := string(PAnsiChar(@param_data[0]));
end;

function TCLDevice.Get: Tcl_device_id;
begin
  Result := FDevice;
end;

function TCLDevice.GetPlatform(platform: TCLPlatform): Tcl_int;
var
  platform_id: Tcl_platform_id;
begin
  Result := clGetDeviceInfo(FDevice, DEVICE_PLATFORM, SizeOf(Tcl_platform_id), @platform_id, nil);
  if Result = CL_SUCCESS then
    platform.FPlatform := platform_id;
end;

// Implementação da classe TCLContext
constructor TCLContext.Create;
begin
  FContext := nil;
end;

constructor TCLContext.Create(const properties: array of Tcl_context_properties; num_devices: Tcl_uint; devices: Pcl_device_id;
  pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall; user_data: Pointer);
var
  err: Tcl_int;
begin
  FContext := clCreateContext(@properties[0], num_devices, devices, pfn_notify, user_data, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create context');
end;

constructor TCLContext.Create(device_type: Tcl_device_type; pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall; user_data: Pointer);
var
  err: Tcl_int;
begin
  FContext := clCreateContextFromType(nil, device_type, pfn_notify, user_data, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create context from type');
end;

destructor TCLContext.Destroy;
begin
  if FContext <> nil then
    clReleaseContext(FContext);
  inherited;
end;

function TCLContext.GetInfo(param_name: Tcl_context_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetContextInfo(FContext, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetContextInfo(FContext, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLContext.Get: Tcl_context;
begin
  Result := FContext;
end;

// Implementação da classe TCLCommandQueue
constructor TCLCommandQueue.Create;
begin
  FQueue := nil;
end;

constructor TCLCommandQueue.Create(context: TCLContext; device: TCLDevice; properties: Tcl_queue_properties);
var
  err: Tcl_int;
begin
  FQueue := clCreateCommandQueue(context.Get, device.Get, properties, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create command queue');
end;

destructor TCLCommandQueue.Destroy;
begin
  if FQueue <> nil then
    clReleaseCommandQueue(FQueue);
  inherited;
end;

function TCLCommandQueue.GetInfo(param_name: Tcl_command_queue_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetCommandQueueInfo(FQueue, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetCommandQueueInfo(FQueue, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLCommandQueue.Get: Tcl_command_queue;
begin
  Result := FQueue;
end;

function TCLCommandQueue.Finish: Tcl_int;
begin
  Result := clFinish(FQueue);
end;

function TCLCommandQueue.Flush: Tcl_int;
begin
  Result := clFlush(FQueue);
end;

// Implementação da classe TCLProgram
constructor TCLProgram.Create;
begin
  FProgram := nil;
end;

constructor TCLProgram.Create(context: TCLContext; count: Tcl_uint; strings: PPAnsiChar; lengths: Pcl_size_t);
var
  err: Tcl_int;
begin
  FProgram := clCreateProgramWithSource(context.Get, count, strings, lengths, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create program with source');
end;

constructor TCLProgram.Create(context: TCLContext; devices: PArray<TCLDevice>; lengths: Pcl_size_t; binaries: PPcl_uchar; binary_status: Pcl_int);
var
  err: Tcl_int;
  device_list: TArray<Tcl_device_id>;
  i: Integer;
begin
  SetLength(device_list, Length(devices^));
  for i := 0 to Length(devices^) - 1 do
    device_list[i] := devices^[i].Get;
  FProgram := clCreateProgramWithBinary(context.Get, Length(devices^), @device_list[0], lengths, binaries, binary_status, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create program with binary');
end;

destructor TCLProgram.Destroy;
begin
  if FProgram <> nil then
    clReleaseProgram(FProgram);
  inherited;
end;

function TCLProgram.GetInfo(param_name: Tcl_program_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetProgramInfo(FProgram, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetProgramInfo(FProgram, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLProgram.GetBuildInfo(device: TCLDevice; param_name: Tcl_program_build_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetProgramBuildInfo(FProgram, device.Get, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetProgramBuildInfo(FProgram, device.Get, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLProgram.Build(devices: PArray<TCLDevice>; options: PAnsiChar; pfn_notify: procedure(program: Tcl_program; user_data: Pointer); stdcall; user_data: Pointer): Tcl_int;
var
  device_list: TArray<Tcl_device_id>;
  i: Integer;
begin
  if devices = nil then
    Result := clBuildProgram(FProgram, 0, nil, options, pfn_notify, user_data)
  else
  begin
    SetLength(device_list, Length(devices^));
    for i := 0 to Length(devices^) - 1 do
      device_list[i] := devices^[i].Get;
    Result := clBuildProgram(FProgram, Length(devices^), @device_list[0], options, pfn_notify, user_data);
  end;
end;

function TCLProgram.Get: Tcl_program;
begin
  Result := FProgram;
end;

// Implementação da classe TCLKernel
constructor TCLKernel.Create;
begin
  FKernel := nil;
end;

constructor TCLKernel.Create(program: TCLProgram; kernel_name: PAnsiChar);
var
  err: Tcl_int;
begin
  FKernel := clCreateKernel(program.Get, kernel_name, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create kernel');
end;

destructor TCLKernel.Destroy;
begin
  if FKernel <> nil then
    clReleaseKernel(FKernel);
  inherited;
end;

function TCLKernel.GetInfo(param_name: Tcl_kernel_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetKernelInfo(FKernel, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetKernelInfo(FKernel, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLKernel.SetArg(arg_index: Tcl_uint; arg_size: Tcl_size_t; arg_value: Pointer): Tcl_int;
begin
  Result := clSetKernelArg(FKernel, arg_index, arg_size, arg_value);
end;

function TCLKernel.Get: Tcl_kernel;
begin
  Result := FKernel;
end;

// Implementação da classe TCLMemory
constructor TCLMemory.Create;
begin
  FMemory := nil;
end;

constructor TCLMemory.Create(context: TCLContext; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer);
var
  err: Tcl_int;
begin
  FMemory := clCreateBuffer(context.Get, flags, size, host_ptr, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create memory object');
end;

destructor TCLMemory.Destroy;
begin
  if FMemory <> nil then
    clReleaseMemObject(FMemory);
  inherited;
end;

function TCLMemory.GetInfo(param_name: Tcl_mem_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetMemObjectInfo(FMemory, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetMemObjectInfo(FMemory, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLMemory.Get: Tcl_mem;
begin
  Result := FMemory;
end;

// Implementação da classe TCLBuffer
constructor TCLBuffer.Create;
begin
  inherited Create;
end;

constructor TCLBuffer.Create(context: TCLContext; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer);
begin
  inherited Create(context, flags, size, host_ptr);
end;

destructor TCLBuffer.Destroy;
begin
  inherited;
end;

// Implementação da classe TCLEvent
constructor TCLEvent.Create;
begin
  FEvent := nil;
end;

constructor TCLEvent.Create(context: TCLContext);
var
  err: Tcl_int;
begin
  FEvent := clCreateUserEvent(context.Get, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create user event');
end;

destructor TCLEvent.Destroy;
begin
  if FEvent <> nil then
    clReleaseEvent(FEvent);
  inherited;
end;

function TCLEvent.GetInfo(param_name: Tcl_event_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetEventInfo(FEvent, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetEventInfo(FEvent, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLEvent.Get: Tcl_event;
begin
  Result := FEvent;
end;

function TCLEvent.Wait: Tcl_int;
begin
  Result := clWaitForEvents(1, @FEvent);
end;

// Implementação da classe TCLSampler
constructor TCLSampler.Create;
begin
  FSampler := nil;
end;

constructor TCLSampler.Create(context: TCLContext; normalized_coords: Tcl_bool; addressing_mode: Tcl_addressing_mode; filter_mode: Tcl_filter_mode);
var
  err: Tcl_int;
begin
  FSampler := clCreateSampler(context.Get, normalized_coords, addressing_mode, filter_mode, @err);
  if err <> CL_SUCCESS then
    raise TCLError.Create(err, 'Failed to create sampler');
end;

destructor TCLSampler.Destroy;
begin
  if FSampler <> nil then
    clReleaseSampler(FSampler);
  inherited;
end;

function TCLSampler.GetInfo(param_name: Tcl_sampler_info; param_value: PString): Tcl_int;
var
  param_size: Tcl_size_t;
  param_data: TArray<AnsiChar>;
begin
  param_size := 0;
  Result := clGetSamplerInfo(FSampler, param_name, 0, nil, @param_size);
  if Result <> CL_SUCCESS then Exit;
  if param_size = 0 then
  begin
    if param_value <> nil then param_value^ := '';
    Result := CL_SUCCESS;
    Exit;
  end;
  SetLength(param_data, param_size);
  Result := clGetSamplerInfo(FSampler, param_name, param_size, @param_data[0], nil);
  if Result <> CL_SUCCESS then Exit;
  if param_value <> nil then
    param_value^ := string(PAnsiChar(@param_data[0]));
end;

function TCLSampler.Get: Tcl_sampler;
begin
  Result := FSampler;
end;

// Funções utilitárias inline
function GetPlatforms(platforms: PArray<TCLPlatform>): Tcl_int;
begin
  Result := TCLPlatform.Get(platforms);
end;

function GetDevices(const platform: TCLPlatform; device_type: Tcl_device_type; devices: PArray<TCLDevice>): Tcl_int;
begin
  Result := platform.GetDevices(device_type, devices);
end;

// Implementação da classe TOpenCLWrapper
constructor TOpenCLWrapper.Create;
begin
  FPlatform := nil;
  FDevice := nil;
  FContext := nil;
  FCommandQueue := nil;
  FProgram := nil;
  FKernel := nil;
  FBuffer := nil;
  FEvent := nil;
  FSampler := nil;
end;

destructor TOpenCLWrapper.Destroy;
begin
  FreeAndNil(FSampler);
  FreeAndNil(FEvent);
  FreeAndNil(FBuffer);
  FreeAndNil(FKernel);
  FreeAndNil(FProgram);
  FreeAndNil(FCommandQueue);
  FreeAndNil(FContext);
  FreeAndNil(FDevice);
  FreeAndNil(FPlatform);
  SetLength(FPlatforms, 0);
  SetLength(FDevices, 0);
  inherited;
end;

procedure TOpenCLWrapper.InitializePlatform(index: Integer = 0);
begin
  GetPlatforms(@FPlatforms);
  if (index >= 0) and (index < Length(FPlatforms)) then
    FPlatform := TCLPlatform.Create(FPlatforms[index])
  else
    raise Exception.Create('Invalid platform index');
end;

procedure TOpenCLWrapper.InitializeDevice(index: Integer = 0; deviceType: Tcl_device_type = DEVICE_TYPE_DEFAULT);
begin
  if FPlatform = nil then
    raise Exception.Create('Platform not initialized');
  GetDevices(FPlatform, deviceType, @FDevices);
  if (index >= 0) and (index < Length(FDevices)) then
    FDevice := TCLDevice.Create(FDevices[index])
  else
    raise Exception.Create('Invalid device index');
end;

procedure TOpenCLWrapper.InitializeContext;
begin
  if FDevice = nil then
    raise Exception.Create('Device not initialized');
  FContext := TCLContext.Create([CONTEXT_PLATFORM, FPlatform.Get, 0], 1, @FDevice.FDevice, nil, nil);
end;

procedure TOpenCLWrapper.InitializeCommandQueue(properties: Tcl_queue_properties = 0);
begin
  if FContext = nil then
    raise Exception.Create('Context not initialized');
  if FDevice = nil then
    raise Exception.Create('Device not initialized');
  FCommandQueue := TCLCommandQueue.Create(FContext, FDevice, properties);
end;

procedure TOpenCLWrapper.InitializeProgramFromSource(const source: string);
var
  src: PAnsiChar;
begin
  if FContext = nil then
    raise Exception.Create('Context not initialized');
  src := PAnsiChar(AnsiString(source));
  FProgram := TCLProgram.Create(FContext, 1, @src, nil);
  FProgram.Build(@FDevices, nil, nil, nil);
end;

procedure TOpenCLWrapper.InitializeKernel(const kernelName: string);
begin
  if FProgram = nil then
    raise Exception.Create('Program not initialized');
  FKernel := TCLKernel.Create(FProgram, PAnsiChar(AnsiString(kernelName)));
end;

procedure TOpenCLWrapper.InitializeBuffer(size: Tcl_size_t; flags: Tcl_mem_flags = MEM_READ_WRITE; hostPtr: Pointer = nil);
begin
  if FContext = nil then
    raise Exception.Create('Context not initialized');
  FBuffer := TCLBuffer.Create(FContext, flags, size, hostPtr);
end;

procedure TOpenCLWrapper.SetKernelArg(argIndex: Tcl_uint; argSize: Tcl_size_t; argValue: Pointer);
begin
  if FKernel = nil then
    raise Exception.Create('Kernel not initialized');
  FKernel.SetArg(argIndex, argSize, argValue);
end;

procedure TOpenCLWrapper.EnqueueNDRangeKernel(workDim: Tcl_uint; globalWorkSize, localWorkSize: Pcl_size_t; event: TCLEvent = nil);
var
  evt: Tcl_event;
begin
  if FCommandQueue = nil then
    raise Exception.Create('Command queue not initialized');
  if FKernel = nil then
    raise Exception.Create('Kernel not initialized');
  evt := nil;
  if event <> nil then evt := event.Get;
  clEnqueueNDRangeKernel(FCommandQueue.Get, FKernel.Get, workDim, nil, globalWorkSize, localWorkSize, 0, nil, @evt);
  if event <> nil then event.FEvent := evt;
end;

procedure TOpenCLWrapper.EnqueueReadBuffer(buffer: TCLBuffer; size: Tcl_size_t; ptr: Pointer; offset: Tcl_size_t = 0; blocking: Boolean = True; event: TCLEvent = nil);
var
  evt: Tcl_event;
begin
  if FCommandQueue = nil then
    raise Exception.Create('Command queue not initialized');
  if buffer = nil then
    raise Exception.Create('Buffer not initialized');
  evt := nil;
  if event <> nil then evt := event.Get;
  clEnqueueReadBuffer(FCommandQueue.Get, buffer.Get, Ord(blocking), offset, size, ptr, 0, nil, @evt);
  if event <> nil then event.FEvent := evt;
end;

procedure TOpenCLWrapper.EnqueueWriteBuffer(buffer: TCLBuffer; size: Tcl_size_t; ptr: Pointer; offset: Tcl_size_t = 0; blocking: Boolean = True; event: TCLEvent = nil);
var
  evt: Tcl_event;
begin
  if FCommandQueue = nil then
    raise Exception.Create('Command queue not initialized');
  if buffer = nil then
    raise Exception.Create('Buffer not initialized');
  evt := nil;
  if event <> nil then evt := event.Get;
  clEnqueueWriteBuffer(FCommandQueue.Get, buffer.Get, Ord(blocking), offset, size, ptr, 0, nil, @evt);
  if event <> nil then event.FEvent := evt;
end;

procedure TOpenCLWrapper.Finish;
begin
  if FCommandQueue = nil then
    raise Exception.Create('Command queue not initialized');
  FCommandQueue.Finish;
end;

function TOpenCLWrapper.GetPlatform: TCLPlatform;
begin
  Result := FPlatform;
end;

function TOpenCLWrapper.GetDevice: TCLDevice;
begin
  Result := FDevice;
end;

function TOpenCLWrapper.GetContext: TCLContext;
begin
  Result := FContext;
end;

function TOpenCLWrapper.GetCommandQueue: TCLCommandQueue;
begin
  Result := FCommandQueue;
end;

function TOpenCLWrapper.GetProgram: TCLProgram;
begin
  Result := FProgram;
end;

function TOpenCLWrapper.GetKernel: TCLKernel;
begin
  Result := FKernel;
end;

function TOpenCLWrapper.GetBuffer: TCLBuffer;
begin
  Result := FBuffer;
end;

function TOpenCLWrapper.GetEvent: TCLEvent;
begin
  Result := FEvent;
end;

function TOpenCLWrapper.GetSampler: TCLSampler;
begin
  Result := FSampler;
end;

end.