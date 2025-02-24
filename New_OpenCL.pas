unit New_OpenCL;

interface

(*
 * Copyright (c) 2011-2022 Khronos Group. Este trabalho é licenciado sob uma
 * Licença Internacional Creative Commons Attribution 4.0
 * SPDX-License-Identifier: Apache-2.0
 *)

{$IFDEF FPC}
  {$MODE Delphi} // Define o modo Delphi para compatibilidade com Free Pascal
{$ELSE}
  {$IFDEF FMX}
    {$DEFINE NO_VCL} // Desativa recursos VCL em projetos FireMonkey
  {$ENDIF}
{$ENDIF}

uses
  SysUtils; // Unidade básica para funções de sistema e manipulação de strings

// Define o wrapper da API OpenCL (equivalente a CL_HPP_OPENCL_API_WRAPPER)
{$IFDEF CL_HPP_OPENCL_API_WRAPPER}
// Não há equivalente direto em Delphi para CL_(name); será tratado nas chamadas de função
{$ELSE}
// Em Delphi, as funções serão declaradas diretamente sem namespace, equivalente a ::name
{$ENDIF}

// Manipula definições de pré-processador depreciadas
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

// Avisa sobre recursos não mais suportados
{$IFDEF __USE_DEV_VECTOR}
  {$MESSAGE Warn '__USE_DEV_VECTOR não é mais suportado. Espere erros de compilação.'}
{$ENDIF}

{$IFDEF __USE_DEV_STRING}
  {$MESSAGE Warn '__USE_DEV_STRING não é mais suportado. Espere erros de compilação.'}
{$ENDIF}

// Define a versão alvo do OpenCL (equivalente a CL_HPP_TARGET_OPENCL_VERSION)
// Se não definida pelo usuário, assume 300 (OpenCL 3.0) como padrão
{$IFNDEF CL_HPP_TARGET_OPENCL_VERSION}
  {$MESSAGE Hint 'CL_HPP_TARGET_OPENCL_VERSION não definida. Será definida como 300 (OpenCL 3.0) por padrão.'}
  {$DEFINE CL_HPP_TARGET_OPENCL_VERSION=300}
{$ENDIF}

// Verifica se a versão alvo é válida (100, 110, 120, 200, 210, 220, 300)
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

// Define a versão mínima suportada (equivalente a CL_HPP_MINIMUM_OPENCL_VERSION)
// Adotamos 1.2 como referência mínima, mas mantemos a estrutura original
{$IFNDEF CL_HPP_MINIMUM_OPENCL_VERSION}
  {$DEFINE CL_HPP_MINIMUM_OPENCL_VERSION=100} // Versão mínima padrão é OpenCL 1.0 (mantida por fidelidade, mas referência é 1.2)
{$ENDIF}

// OpenCL 1.1 ou superior é requerido no original, mas adotamos 1.2 como referência mínima
{$IF CL_HPP_MINIMUM_OPENCL_VERSION < 110}
  {$MESSAGE Warn 'opencl.hpp requer pelo menos OpenCL 1.1. Defina CL_HPP_MINIMUM_OPENCL_VERSION >= 110 ou use uma versão mais antiga destas bindings.'}
{$ENDIF}

// Define as versões específicas do OpenCL com base na versão alvo
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 100}
  {$DEFINE CL_VERSION_1_0} // OpenCL 1.0
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 110}
  {$DEFINE CL_VERSION_1_1} // OpenCL 1.1
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 120}
  {$DEFINE CL_VERSION_1_2} // OpenCL 1.2
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 200}
  {$DEFINE CL_VERSION_2_0} // OpenCL 2.0
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 210}
  {$DEFINE CL_VERSION_2_1} // OpenCL 2.1
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 220}
  {$DEFINE CL_VERSION_2_2} // OpenCL 2.2
{$ENDIF}
{$IF CL_HPP_TARGET_OPENCL_VERSION >= 300}
  {$DEFINE CL_VERSION_3_0} // OpenCL 3.0
{$ENDIF}

// Define tipos fixos para plataformas antigas que não incluem cl_platform.h
const
  CL_SFIXED14_UINT32_MAX = $3FFF; // Valor máximo para tipo fixo de 14 bits sem sinal
  CL_SFIXED14_INT32_MAX  = $1FFF; // Valor máximo para tipo fixo de 14 bits com sinal
  CL_SFIXED14_INT32_MIN  = -$2000; // Valor mínimo para tipo fixo de 14 bits com sinal

// Tipos básicos do OpenCL (equivalentes aos definidos em cl.h)
type
  Tcl_platform_id = type Pointer;         // Identificador opaco de uma plataforma OpenCL
  Pcl_platform_id = ^Tcl_platform_id;     // Ponteiro para o identificador de plataforma
  Tcl_device_id = type Pointer;           // Identificador opaco de um dispositivo OpenCL
  Pcl_device_id = ^Tcl_device_id;         // Ponteiro para o identificador de dispositivo
  Tcl_context = type Pointer;             // Identificador opaco de um contexto OpenCL
  Pcl_context = ^Tcl_context;             // Ponteiro para o identificador de contexto
  Tcl_command_queue = type Pointer;       // Identificador opaco de uma fila de comandos OpenCL
  Pcl_command_queue = ^Tcl_command_queue; // Ponteiro para o identificador de fila de comandos
  Tcl_mem = type Pointer;                 // Identificador opaco de um objeto de memória OpenCL (ex.: buffer)
  Pcl_mem = ^Tcl_mem;                     // Ponteiro para o identificador de objeto de memória
  Tcl_event = type Pointer;               // Identificador opaco de um evento OpenCL
  Pcl_event = ^Tcl_event;                 // Ponteiro para o identificador de evento
  Tcl_kernel = type Pointer;              // Identificador opaco de um kernel OpenCL
  Pcl_kernel = ^Tcl_kernel;               // Ponteiro para o identificador de kernel
  Tcl_program = type Pointer;             // Identificador opaco de um programa OpenCL
  Pcl_program = ^Tcl_program;             // Ponteiro para o identificador de programa
  Tcl_sampler = type Pointer;             // Identificador opaco de um amostrador OpenCL
  Pcl_sampler = ^Tcl_sampler;             // Ponteiro para o identificador de amostrador

  Tcl_char = ShortInt;                    // Tipo de 8 bits com sinal (equivalente a char em C)
  Pcl_char = ^Tcl_char;                   // Ponteiro para tipo de 8 bits com sinal
  Tcl_uchar = Byte;                       // Tipo de 8 bits sem sinal (equivalente a unsigned char em C)
  Pcl_uchar = ^Tcl_uchar;                 // Ponteiro para tipo de 8 bits sem sinal
  Tcl_short = SmallInt;                   // Tipo de 16 bits com sinal (equivalente a short em C)
  Pcl_short = ^Tcl_short;                 // Ponteiro para tipo de 16 bits com sinal
  Tcl_ushort = Word;                      // Tipo de 16 bits sem sinal (equivalente a unsigned short em C)
  Pcl_ushort = ^Tcl_ushort;               // Ponteiro para tipo de 16 bits sem sinal
  Tcl_int = Integer;                      // Tipo de 32 bits com sinal (equivalente a int em C)
  Pcl_int = ^Tcl_int;                     // Ponteiro para tipo de 32 bits com sinal
  Tcl_uint = Cardinal;                    // Tipo de 32 bits sem sinal (equivalente a unsigned int em C)
  Pcl_uint = ^Tcl_uint;                   // Ponteiro para tipo de 32 bits sem sinal
  Tcl_long = Int64;                       // Tipo de 64 bits com sinal (equivalente a long em C)
  Pcl_long = ^Tcl_long;                   // Ponteiro para tipo de 64 bits com sinal
  Tcl_ulong = UInt64;                     // Tipo de 64 bits sem sinal (equivalente a unsigned long em C)
  Pcl_ulong = ^Tcl_ulong;                 // Ponteiro para tipo de 64 bits sem sinal
  Tcl_float = Single;                     // Tipo de ponto flutuante de 32 bits (equivalente a float em C)
  Pcl_float = ^Tcl_float;                 // Ponteiro para tipo de ponto flutuante de 32 bits
  Tcl_double = Double;                    // Tipo de ponto flutuante de 64 bits (equivalente a double em C)
  Pcl_double = ^Tcl_double;               // Ponteiro para tipo de ponto flutuante de 64 bits

  // Tipo size_type (equivalente a ::size_t ou unsigned int dependendo da configuração)
  {$IFNDEF CL_HPP_ENABLE_SIZE_T_COMPATIBILITY}
    Tcl_size_t = NativeUInt;              // Tipo usado para tamanhos e offsets (equivalente a size_t em C)
  {$ELSE}
    Tcl_size_t = Cardinal;                // Compatibilidade com versões antigas (equivalente a unsigned int)
  {$ENDIF}
  Pcl_size_t = ^Tcl_size_t;               // Ponteiro para tipo de tamanho/offset

  Tcl_device_type = Tcl_ulong;            // Tipo usado para especificar tipos de dispositivos (ex.: CPU, GPU)
  Pcl_device_type = ^Tcl_device_type;     // Ponteiro para tipo de dispositivo
  Tcl_context_properties = Tcl_long;      // Tipo usado para propriedades do contexto (ex.: plataforma associada)
  Pcl_context_properties = ^Tcl_context_properties; // Ponteiro para propriedades do contexto
  Tcl_queue_properties = Tcl_long;        // Tipo usado para propriedades da fila de comandos (ex.: profiling)
  Pcl_queue_properties = ^Tcl_queue_properties; // Ponteiro para propriedades da fila de comandos
  Tcl_mem_flags = Tcl_ulong;              // Tipo usado para flags de memória (ex.: leitura/escrita)
  Pcl_mem_flags = ^Tcl_mem_flags;         // Ponteiro para flags de memória
  Tcl_bool = Tcl_int;                     // Tipo booleano usado pela API OpenCL (0 = falso, diferente de 0 = verdadeiro)
  Pcl_bool = ^Tcl_bool;                   // Ponteiro para tipo booleano
  Tcl_platform_info = Tcl_uint;           // Tipo para informações da plataforma
  Pcl_platform_info = ^Tcl_platform_info; // Ponteiro para informações da plataforma
  Tcl_device_info = Tcl_uint;             // Tipo para informações do dispositivo
  Pcl_device_info = ^Tcl_device_info;     // Ponteiro para informações do dispositivo
  Tcl_context_info = Tcl_uint;            // Tipo para informações do contexto
  Pcl_context_info = ^Tcl_context_info;   // Ponteiro para informações do contexto
  Tcl_command_queue_info = Tcl_uint;      // Tipo para informações da fila de comandos
  Pcl_command_queue_info = ^Tcl_command_queue_info; // Ponteiro para informações da fila de comandos
  Tcl_program_info = Tcl_uint;            // Tipo para informações do programa
  Pcl_program_info = ^Tcl_program_info;   // Ponteiro para informações do programa
  Tcl_program_build_info = Tcl_uint;      // Tipo para informações de construção do programa
  Pcl_program_build_info = ^Tcl_program_build_info; // Ponteiro para informações de construção do programa
  Tcl_kernel_info = Tcl_uint;             // Tipo para informações do kernel
  Pcl_kernel_info = ^Tcl_kernel_info;     // Ponteiro para informações do kernel
  Tcl_event_info = Tcl_uint;              // Tipo para informações do evento
  Pcl_event_info = ^Tcl_event_info;       // Ponteiro para informações do evento
  Tcl_sampler_info = Tcl_uint;            // Tipo para informações do amostrador
  Pcl_sampler_info = ^Tcl_sampler_info;   // Ponteiro para informações do amostrador
  Tcl_addressing_mode = Tcl_uint;         // Tipo para modo de endereçamento do amostrador
  Pcl_addressing_mode = ^Tcl_addressing_mode; // Ponteiro para modo de endereçamento
  Tcl_filter_mode = Tcl_uint;             // Tipo para modo de filtro do amostrador
  Pcl_filter_mode = ^Tcl_filter_mode;     // Ponteiro para modo de filtro
  Tcl_command_type = Tcl_uint;            // Tipo para tipo de comando do evento
  Pcl_command_type = ^Tcl_command_type;   // Ponteiro para tipo de comando

  // Typedefs legados para compatibilidade
  Tcl_error_code = Tcl_int;               // Código de erro (equivalente a cl_int)
  // binary_type será representado como TBytes em Delphi (equivalente a std::vector<unsigned char>)
  // string_type será representado como string em Delphi (equivalente a std::string)

  // Constantes de erro (definidas em cl.h, repetidas aqui para referência)
const
  CL_SUCCESS                                  = 0;    // Operação concluída com sucesso
  CL_DEVICE_NOT_FOUND                         = -1;   // Dispositivo não encontrado
  CL_DEVICE_NOT_AVAILABLE                     = -2;   // Dispositivo não disponível
  CL_COMPILER_NOT_AVAILABLE                   = -3;   // Compilador não disponível
  CL_MEM_OBJECT_ALLOCATION_FAILURE            = -4;   // Falha na alocação de objeto de memória
  CL_OUT_OF_RESOURCES                         = -5;   // Recursos insuficientes
  CL_OUT_OF_HOST_MEMORY                       = -6;   // Memória do host insuficiente
  CL_PROFILING_INFO_NOT_AVAILABLE             = -7;   // Informações de perfilamento não disponíveis
  CL_MEM_COPY_OVERLAP                         = -8;   // Sobreposição na cópia de memória
  CL_IMAGE_FORMAT_MISMATCH                    = -9;   // Formato de imagem incompatível
  CL_IMAGE_FORMAT_NOT_SUPPORTED               = -10;  // Formato de imagem não suportado
  CL_BUILD_PROGRAM_FAILURE                    = -11;  // Falha na construção do programa
  CL_MAP_FAILURE                              = -12;  // Falha no mapeamento de memória
  CL_MISALIGNED_SUB_BUFFER_OFFSET             = -13;  // Offset de sub-buffer desalinhado
  CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = -14; // Erro de status de execução para eventos na lista de espera
  CL_COMPILE_PROGRAM_FAILURE                  = -15;  // Falha na compilação do programa
  CL_LINKER_NOT_AVAILABLE                     = -16;  // Linker não disponível
  CL_LINK_PROGRAM_FAILURE                     = -17;  // Falha no linkage do programa
  CL_DEVICE_PARTITION_FAILED                  = -18;  // Falha na partição do dispositivo
  CL_KERNEL_ARG_INFO_NOT_AVAILABLE            = -19;  // Informações de argumento do kernel não disponíveis
  CL_INVALID_VALUE                            = -30;  // Valor inválido fornecido
  CL_INVALID_DEVICE_TYPE                      = -31;  // Tipo de dispositivo inválido
  CL_INVALID_PLATFORM                         = -32;  // Plataforma inválida
  CL_INVALID_DEVICE                           = -33;  // Dispositivo inválido
  CL_INVALID_CONTEXT                          = -34;  // Contexto inválido
  CL_INVALID_QUEUE_PROPERTIES                 = -35;  // Propriedades da fila inválidas
  CL_INVALID_COMMAND_QUEUE                    = -36;  // Fila de comandos inválida
  CL_INVALID_HOST_PTR                         = -37;  // Ponteiro do host inválido
  CL_INVALID_MEM_OBJECT                       = -38;  // Objeto de memória inválido
  CL_INVALID_IMAGE_FORMAT_DESCRIPTOR          = -39;  // Descritor de formato de imagem inválido
  CL_INVALID_IMAGE_SIZE                       = -40;  // Tamanho de imagem inválido
  CL_INVALID_SAMPLER                          = -41;  // Amostrador inválido
  CL_INVALID_BINARY                           = -42;  // Binário inválido
  CL_INVALID_BUILD_OPTIONS                    = -43;  // Opções de construção inválidas
  CL_INVALID_PROGRAM                          = -44;  // Programa inválido
  CL_INVALID_PROGRAM_EXECUTABLE               = -45;  // Executável do programa inválido
  CL_INVALID_KERNEL_NAME                      = -46;  // Nome do kernel inválido
  CL_INVALID_KERNEL_DEFINITION                = -47;  // Definição do kernel inválida
  CL_INVALID_KERNEL                           = -48;  // Kernel inválido
  CL_INVALID_ARG_INDEX                        = -49;  // Índice de argumento inválido
  CL_INVALID_ARG_VALUE                        = -50;  // Valor de argumento inválido
  CL_INVALID_ARG_SIZE                         = -51;  // Tamanho de argumento inválido
  CL_INVALID_KERNEL_ARGS                      = -52;  // Argumentos do kernel inválidos
  CL_INVALID_WORK_DIMENSION                   = -53;  // Dimensão de trabalho inválida
  CL_INVALID_WORK_GROUP_SIZE                  = -54;  // Tamanho do grupo de trabalho inválido
  CL_INVALID_WORK_ITEM_SIZE                   = -55;  // Tamanho do item de trabalho inválido
  CL_INVALID_GLOBAL_OFFSET                    = -56;  // Offset global inválido
  CL_INVALID_EVENT_WAIT_LIST                  = -57;  // Lista de espera de eventos inválida
  CL_INVALID_EVENT                            = -58;  // Evento inválido
  CL_INVALID_OPERATION                        = -59;  // Operação inválida
  CL_INVALID_GL_OBJECT                        = -60;  // Objeto GL inválido
  CL_INVALID_BUFFER_SIZE                      = -61;  // Tamanho de buffer inválido
  CL_INVALID_MIP_LEVEL                        = -62;  // Nível MIP inválido
  CL_INVALID_GLOBAL_WORK_SIZE                 = -63;  // Tamanho global de trabalho inválido
  CL_INVALID_PROPERTY                         = -64;  // Propriedade inválida
  CL_INVALID_IMAGE_DESCRIPTOR                 = -65;  // Descritor de imagem inválido
  CL_INVALID_COMPILER_OPTIONS                 = -66;  // Opções de compilador inválidas
  CL_INVALID_LINKER_OPTIONS                   = -67;  // Opções de linker inválidas
  CL_INVALID_DEVICE_PARTITION_COUNT           = -68;  // Contagem de partição de dispositivo inválida

// Declarações antecipadas das classes
type
  TCLPlatform = class;      // Classe para encapsular uma plataforma OpenCL
  TCLDevice = class;        // Classe para encapsular um dispositivo OpenCL
  TCLContext = class;       // Classe para encapsular um contexto OpenCL
  TCLCommandQueue = class;  // Classe para encapsular uma fila de comandos OpenCL
  TCLProgram = class;       // Classe para encapsular um programa OpenCL
  TCLKernel = class;        // Classe para encapsular um kernel OpenCL
  TCLMemory = class;        // Classe para encapsular um objeto de memória OpenCL
  TCLBuffer = class;        // Classe para encapsular um buffer OpenCL
  TCLEvent = class;         // Classe para encapsular um evento OpenCL
  TCLSampler = class;       // Classe para encapsular um amostrador OpenCL

{$IFDEF CL_HPP_ENABLE_EXCEPTIONS}
// Classe de erro (equivalente a cl::Error em C++)
type
  TCLError = class(Exception) // Exceção para erros OpenCL
  private
    FErr: Tcl_int;            // Código de erro OpenCL
    FErrStr: string;          // Mensagem de erro associada
  public
    constructor Create(err: Tcl_int; errStr: PAnsiChar = nil); // Construtor com código de erro e mensagem opcional
    function Err: Tcl_int; // Retorna o código de erro
    // Em Delphi, a mensagem é acessada via propriedade Message herdada de Exception
  end;
{$ENDIF}

{$IFNDEF CL_HPP_USER_OVERRIDE_ERROR_STRINGS}
// Função para obter string de erro (equivalente a cl::errorString)
function ErrorString(error: Tcl_int): string; // Retorna a descrição do erro em inglês
{$ENDIF}

{$IFDEF CL_HPP_ENABLE_EXCEPTIONS}
// Função auxiliar para verificar erros e lançar exceções
procedure ErrChk(err: Tcl_int; operation: PAnsiChar); // Verifica erro e lança TCLError se necessário
{$ENDIF}

// Ponteiros para funções da API OpenCL
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

  TclRetainProgram_fn = function(aprogram: Tcl_program): Tcl_int; stdcall;

  TclReleaseProgram_fn = function(aprogram: Tcl_program): Tcl_int; stdcall;

  TclBuildProgram_fn = function(
    aprogram: Tcl_program; num_devices: Tcl_uint; device_list: Pcl_device_id;
    options: PAnsiChar; pfn_notify: procedure(aprogram: Tcl_program; user_data: Pointer); stdcall;
    user_data: Pointer): Tcl_int; stdcall;

  TclCreateKernel_fn = function(
    aprogram: Tcl_program; kernel_name: PAnsiChar; errcode_ret: Pcl_int): Tcl_kernel; stdcall;

  TclCreateKernelsInProgram_fn = function(
    aprogram: Tcl_program; num_kernels: Tcl_uint; kernels: Pcl_kernel; num_kernels_ret: Pcl_uint): Tcl_int; stdcall;

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
    pfn_notify: procedure(aprogram: Tcl_program; user_data: Pointer); stdcall;
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

// Constantes de utilidade
const
  ALL_DEVICES: Tcl_size_t = -1; // Representa todos os dispositivos

// Constantes de plataforma
const
  PLATFORM_PROFILE     = $0900; // Perfil da plataforma
  PLATFORM_VERSION     = $0901; // Versão da plataforma
  PLATFORM_NAME        = $0902; // Nome da plataforma
  PLATFORM_VENDOR      = $0903; // Fornecedor da plataforma
  PLATFORM_EXTENSIONS  = $0904; // Extensões suportadas pela plataforma
{$IFDEF CL_VERSION_2_1}
  PLATFORM_HOST_TIMER_RESOLUTION = $0905; // Resolução do temporizador do host
{$ENDIF}

// Constantes de tipo de dispositivo
const
  DEVICE_TYPE_DEFAULT    = (1 shl 0); // Dispositivo padrão
  DEVICE_TYPE_CPU        = (1 shl 1); // CPU
  DEVICE_TYPE_GPU        = (1 shl 2); // GPU
  DEVICE_TYPE_ACCELERATOR = (1 shl 3); // Acelerador
  DEVICE_TYPE_CUSTOM     = (1 shl 4); // Dispositivo personalizado
  DEVICE_TYPE_ALL        = $FFFFFFFF; // Todos os tipos de dispositivos

// Constantes de informações do dispositivo
const
  DEVICE_TYPE                          = $1000; // Tipo de dispositivo
  DEVICE_VENDOR_ID                     = $1001; // ID do fornecedor
  DEVICE_MAX_COMPUTE_UNITS             = $1002; // Número máximo de unidades de computação
  DEVICE_MAX_WORK_ITEM_DIMENSIONS      = $1003; // Máximo de dimensões de itens de trabalho
  DEVICE_MAX_WORK_GROUP_SIZE           = $1004; // Tamanho máximo do grupo de trabalho
  DEVICE_MAX_WORK_ITEM_SIZES           = $1005; // Tamanhos máximos dos itens de trabalho
  DEVICE_PREFERRED_VECTOR_WIDTH_CHAR   = $1006; // Largura preferida de vetor para char
  DEVICE_PREFERRED_VECTOR_WIDTH_SHORT  = $1007; // Largura preferida de vetor para short
  DEVICE_PREFERRED_VECTOR_WIDTH_INT    = $1008; // Largura preferida de vetor para int
  DEVICE_PREFERRED_VECTOR_WIDTH_LONG   = $1009; // Largura preferida de vetor para long
  DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT  = $100A; // Largura preferida de vetor para float
  DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE = $100B; // Largura preferida de vetor para double
  DEVICE_MAX_CLOCK_FREQUENCY           = $100C; // Frequência máxima do clock (em MHz)
  DEVICE_ADDRESS_BITS                  = $100D; // Número de bits de endereço
  DEVICE_MAX_READ_IMAGE_ARGS           = $100E; // Máximo de argumentos de imagem de leitura
  DEVICE_MAX_WRITE_IMAGE_ARGS          = $100F; // Máximo de argumentos de imagem de escrita
  DEVICE_MAX_MEM_ALLOC_SIZE            = $1010; // Tamanho máximo de alocação de memória
  DEVICE_IMAGE2D_MAX_WIDTH             = $1011; // Largura máxima de imagem 2D
  DEVICE_IMAGE2D_MAX_HEIGHT            = $1012; // Altura máxima de imagem 2D
  DEVICE_IMAGE3D_MAX_WIDTH             = $1013; // Largura máxima de imagem 3D
  DEVICE_IMAGE3D_MAX_HEIGHT            = $1014; // Altura máxima de imagem 3D
  DEVICE_IMAGE3D_MAX_DEPTH             = $1015; // Profundidade máxima de imagem 3D
  DEVICE_IMAGE_SUPPORT                 = $1016; // Suporte a imagens (verdadeiro/falso)
  DEVICE_MAX_PARAMETER_SIZE            = $1017; // Tamanho máximo de parâmetro
  DEVICE_MAX_SAMPLERS                  = $1018; // Número máximo de amostradores
  DEVICE_MEM_BASE_ADDR_ALIGN           = $1019; // Alinhamento do endereço base da memória
  DEVICE_MIN_DATA_TYPE_ALIGN_SIZE      = $101A; // Tamanho mínimo de alinhamento de tipo de dado
  DEVICE_SINGLE_FP_CONFIG              = $101B; // Configuração de ponto flutuante single
  DEVICE_GLOBAL_MEM_CACHE_TYPE         = $101C; // Tipo de cache de memória global
  DEVICE_GLOBAL_MEM_CACHELINE_SIZE     = $101D; // Tamanho da linha de cache de memória global
  DEVICE_GLOBAL_MEM_CACHE_SIZE         = $101E; // Tamanho do cache de memória global
  DEVICE_GLOBAL_MEM_SIZE               = $101F; // Tamanho da memória global
  DEVICE_MAX_CONSTANT_BUFFER_SIZE      = $1020; // Tamanho máximo do buffer de constantes
  DEVICE_MAX_CONSTANT_ARGS             = $1021; // Número máximo de argumentos constantes
  DEVICE_LOCAL_MEM_TYPE                = $1022; // Tipo de memória local
  DEVICE_LOCAL_MEM_SIZE                = $1023; // Tamanho da memória local
  DEVICE_ERROR_CORRECTION_SUPPORT      = $1024; // Suporte a correção de erros (verdadeiro/falso)
  DEVICE_PROFILING_TIMER_RESOLUTION    = $1025; // Resolução do temporizador de perfilamento
  DEVICE_ENDIAN_LITTLE                 = $1026; // Endianness little (verdadeiro/falso)
  DEVICE_AVAILABLE                     = $1027; // Disponibilidade do dispositivo (verdadeiro/falso)
  DEVICE_COMPILER_AVAILABLE            = $1028; // Compilador disponível (verdadeiro/falso)
  DEVICE_EXECUTION_CAPABILITIES        = $1029; // Capacidades de execução
  DEVICE_QUEUE_PROPERTIES              = $102A; // Propriedades da fila (obsoleto em 2.0)
{$IFDEF CL_VERSION_2_0}
  DEVICE_QUEUE_ON_HOST_PROPERTIES      = $102A; // Propriedades da fila no host (substitui em 2.0+)
{$ENDIF}
  DEVICE_NAME                          = $102B; // Nome do dispositivo
  DEVICE_VENDOR                        = $102C; // Fornecedor do dispositivo
  DEVICE_DRIVER_VERSION                = $102D; // Versão do driver
  DEVICE_PROFILE                       = $102E; // Perfil do dispositivo
  DEVICE_VERSION                       = $102F; // Versão do dispositivo
  DEVICE_EXTENSIONS                    = $1030; // Extensões suportadas pelo dispositivo
  DEVICE_PLATFORM                      = $1031; // Plataforma associada ao dispositivo
{$IFDEF CL_VERSION_1_1}
  DEVICE_PREFERRED_VECTOR_WIDTH_HALF   = $1034; // Largura preferida de vetor para half
  DEVICE_HOST_UNIFIED_MEMORY           = $1035; // Memória unificada com o host (verdadeiro/falso)
  DEVICE_NATIVE_VECTOR_WIDTH_CHAR      = $1036; // Largura nativa de vetor para char
  DEVICE_NATIVE_VECTOR_WIDTH_SHORT     = $1037; // Largura nativa de vetor para short
  DEVICE_NATIVE_VECTOR_WIDTH_INT       = $1038; // Largura nativa de vetor para int
  DEVICE_NATIVE_VECTOR_WIDTH_LONG      = $1039; // Largura nativa de vetor para long
  DEVICE_NATIVE_VECTOR_WIDTH_FLOAT     = $103A; // Largura nativa de vetor para float
  DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE    = $103B; // Largura nativa de vetor para double
  DEVICE_NATIVE_VECTOR_WIDTH_HALF      = $103C; // Largura nativa de vetor para half
  DEVICE_OPENCL_C_VERSION              = $103D; // Versão do OpenCL C suportada
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  DEVICE_LINKER_AVAILABLE              = $103E; // Linker disponível (verdadeiro/falso)
  DEVICE_BUILT_IN_KERNELS              = $103F; // Lista de kernels integrados
  DEVICE_IMAGE_MAX_BUFFER_SIZE         = $1040; // Tamanho máximo do buffer de imagem
  DEVICE_IMAGE_MAX_ARRAY_SIZE          = $1041; // Tamanho máximo do array de imagens
  DEVICE_PARENT_DEVICE                 = $1042; // Dispositivo pai (para subdispositivos)
  DEVICE_PARTITION_MAX_SUB_DEVICES     = $1043; // Máximo de subdispositivos na partição
  DEVICE_PARTITION_PROPERTIES          = $1044; // Propriedades de partição suportadas
  DEVICE_PARTITION_AFFINITY_DOMAIN     = $1045; // Domínio de afinidade de partição
  DEVICE_PARTITION_TYPE                = $1046; // Tipo de partição aplicada
  DEVICE_REFERENCE_COUNT               = $1047; // Contagem de referências do dispositivo
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  DEVICE_QUEUE_ON_DEVICE_PROPERTIES    = $104A; // Propriedades da fila no dispositivo
  DEVICE_QUEUE_ON_DEVICE_PREFERRED_SIZE = $104B; // Tamanho preferido da fila no dispositivo
  DEVICE_QUEUE_ON_DEVICE_MAX_SIZE      = $104C; // Tamanho máximo da fila no dispositivo
  DEVICE_MAX_ON_DEVICE_QUEUES          = $104D; // Número máximo de filas no dispositivo
  DEVICE_MAX_ON_DEVICE_EVENTS          = $104E; // Número máximo de eventos no dispositivo
  DEVICE_SVM_CAPABILITIES              = $104F; // Capacidades de memória virtual compartilhada (SVM)
  DEVICE_GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE = $1050; // Tamanho total preferido de variáveis globais
  DEVICE_MAX_PIPE_ARGS                 = $1051; // Número máximo de argumentos de pipe
  DEVICE_PIPE_MAX_ACTIVE_RESERVATIONS  = $1052; // Máximo de reservas ativas de pipe
  DEVICE_PIPE_MAX_PACKET_SIZE          = $1053; // Tamanho máximo de pacote de pipe
  DEVICE_PREFERRED_PLATFORM_ATOMIC_ALIGNMENT = $1054; // Alinhamento atômico preferido da plataforma
  DEVICE_PREFERRED_GLOBAL_ATOMIC_ALIGNMENT = $1055; // Alinhamento atômico global preferido
  DEVICE_PREFERRED_LOCAL_ATOMIC_ALIGNMENT = $1056; // Alinhamento atômico local preferido
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  DEVICE_IL_VERSION                    = $105B; // Versão do Intermediate Language (IL)
  DEVICE_MAX_NUM_SUB_GROUPS            = $105C; // Número máximo de subgrupos
  DEVICE_SUB_GROUP_INDEPENDENT_FORWARD_PROGRESS = $105D; // Progresso independente de subgrupos
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  DEVICE_NUMERIC_VERSION               = $105E; // Versão numérica do dispositivo
  DEVICE_EXTENSIONS_WITH_VERSION       = $105F; // Extensões com versão
  DEVICE_ILS_WITH_VERSION              = $1060; // Intermediate Languages com versão
  DEVICE_BUILT_IN_KERNELS_WITH_VERSION = $1061; // Kernels integrados com versão
  DEVICE_ATOMIC_MEMORY_CAPABILITIES    = $1062; // Capacidades de memória atômica
  DEVICE_ATOMIC_FENCE_CAPABILITIES     = $1063; // Capacidades de cercas atômicas
  DEVICE_NON_UNIFORM_WORK_GROUP_SUPPORT = $1064; // Suporte a grupos de trabalho não uniformes
  DEVICE_OPENCL_C_ALL_VERSIONS         = $1065; // Todas as versões do OpenCL C suportadas
  DEVICE_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = $1066; // Múltiplo preferido do tamanho do grupo de trabalho
  DEVICE_WORK_GROUP_COLLECTIVE_FUNCTIONS_SUPPORT = $1067; // Suporte a funções coletivas de grupo de trabalho
  DEVICE_GENERIC_ADDRESS_SPACE_SUPPORT = $1068; // Suporte a espaço de endereço genérico
  DEVICE_OPENCL_C_FEATURES             = $106F; // Recursos do OpenCL C
  DEVICE_DEVICE_ENQUEUE_CAPABILITIES   = $1070; // Capacidades de enfileiramento no dispositivo
  DEVICE_PIPE_SUPPORT                  = $1071; // Suporte a pipes
  DEVICE_LATEST_CONFORMANCE_VERSION_PASSED = $1072; // Última versão de conformidade aprovada
{$ENDIF}

// Constantes de propriedades do contexto
const
  CONTEXT_PLATFORM         = $1084; // Plataforma associada ao contexto
{$IFDEF CL_VERSION_1_1}
  CONTEXT_INTEROP_USER_SYNC = $1085; // Sincronização de interoperabilidade pelo usuário
{$ENDIF}

// Constantes de informações do contexto
const
  CONTEXT_REFERENCE_COUNT  = $1080; // Contagem de referências do contexto
  CONTEXT_DEVICES          = $1081; // Lista de dispositivos no contexto
  CONTEXT_PROPERTIES       = $1082; // Propriedades do contexto
{$IFDEF CL_VERSION_1_1}
  CONTEXT_NUM_DEVICES      = $1083; // Número de dispositivos no contexto
{$ENDIF}

// Constantes de propriedades da fila de comandos
const
  QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE = (1 shl 0); // Habilita modo de execução fora de ordem
  QUEUE_PROFILING_ENABLE             = (1 shl 1); // Habilita perfilamento da fila
{$IFDEF CL_VERSION_2_0}
  QUEUE_ON_DEVICE                    = (1 shl 2); // Fila executada no dispositivo
  QUEUE_ON_DEVICE_DEFAULT            = (1 shl 3); // Fila padrão no dispositivo
{$ENDIF}

// Constantes de informações da fila de comandos
const
  QUEUE_CONTEXT          = $1090; // Contexto associado à fila
  QUEUE_DEVICE           = $1091; // Dispositivo associado à fila
  QUEUE_REFERENCE_COUNT  = $1092; // Contagem de referências da fila
  QUEUE_PROPERTIES       = $1093; // Propriedades da fila
{$IFDEF CL_VERSION_2_0}
  QUEUE_SIZE             = $1094; // Tamanho da fila (em bytes)
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  QUEUE_DEVICE_DEFAULT   = $1095; // Fila padrão do dispositivo
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  QUEUE_PROPERTIES_ARRAY = $1098; // Array de propriedades da fila
{$ENDIF}

// Constantes de flags de memória
const
  MEM_READ_WRITE         = (1 shl 0); // Buffer com acesso de leitura e escrita
  MEM_WRITE_ONLY         = (1 shl 1); // Buffer somente para escrita
  MEM_READ_ONLY          = (1 shl 2); // Buffer somente para leitura
  MEM_USE_HOST_PTR       = (1 shl 3); // Usa ponteiro do host fornecido
  MEM_ALLOC_HOST_PTR     = (1 shl 4); // Aloca memória no host
  MEM_COPY_HOST_PTR      = (1 shl 5); // Copia dados do ponteiro do host
{$IFDEF CL_VERSION_1_2}
  MEM_HOST_WRITE_ONLY    = (1 shl 7); // Host tem acesso somente de escrita
  MEM_HOST_READ_ONLY     = (1 shl 8); // Host tem acesso somente de leitura
  MEM_HOST_NO_ACCESS     = (1 shl 9); // Host não tem acesso
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  MEM_KERNEL_READ_AND_WRITE = (1 shl 10); // Leitura e escrita pelo kernel
{$ENDIF}

// Constantes de informações de objeto de memória
const
  MEM_TYPE               = $1100; // Tipo de objeto de memória
  MEM_FLAGS              = $1101; // Flags de criação do objeto de memória
  MEM_SIZE               = $1102; // Tamanho do objeto de memória
  MEM_HOST_PTR           = $1103; // Ponteiro do host associado
  MEM_MAP_COUNT          = $1104; // Contagem de mapeamentos do objeto
  MEM_REFERENCE_COUNT    = $1105; // Contagem de referências do objeto
  MEM_CONTEXT            = $1106; // Contexto associado ao objeto
{$IFDEF CL_VERSION_1_1}
  MEM_ASSOCIATED_MEMOBJECT = $1107; // Objeto de memória associado (ex.: sub-buffer)
  MEM_OFFSET             = $1108; // Offset do objeto de memória
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  MEM_USES_SVM_POINTER   = $1109; // Usa ponteiro SVM
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  MEM_PROPERTIES         = $110A; // Propriedades do objeto de memória
{$ENDIF}

// Constantes de informações do programa
const
  PROGRAM_REFERENCE_COUNT = $1160; // Contagem de referências do programa
  PROGRAM_CONTEXT        = $1161; // Contexto associado ao programa
  PROGRAM_NUM_DEVICES    = $1162; // Número de dispositivos associados
  PROGRAM_DEVICES        = $1163; // Lista de dispositivos associados
  PROGRAM_SOURCE         = $1164; // Código-fonte do programa
  PROGRAM_BINARY_SIZES   = $1165; // Tamanhos dos binários do programa
  PROGRAM_BINARIES       = $1166; // Binários do programa
{$IFDEF CL_VERSION_1_2}
  PROGRAM_NUM_KERNELS    = $1167; // Número de kernels no programa
  PROGRAM_KERNEL_NAMES   = $1168; // Nomes dos kernels no programa
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  PROGRAM_IL             = $1169; // Intermediate Language (IL) do programa
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  PROGRAM_SCOPE_GLOBAL_CTORS_PRESENT = $116A; // Presença de construtores globais no escopo
  PROGRAM_SCOPE_GLOBAL_DTORS_PRESENT = $116B; // Presença de destruidores globais no escopo
{$ENDIF}

// Constantes de estado de construção do programa
const
  CL_BUILD_SUCCESS       = 0;  // Construção concluída com sucesso
  CL_BUILD_NONE          = -1; // Nenhuma construção realizada
  CL_BUILD_ERROR         = -2; // Erro durante a construção
  CL_BUILD_IN_PROGRESS   = -3; // Construção em andamento

// Constantes de informações de construção do programa
const
  PROGRAM_BUILD_STATUS   = $1181; // Status da construção do programa
  PROGRAM_BUILD_OPTIONS  = $1182; // Opções usadas na construção do programa
  PROGRAM_BUILD_LOG      = $1183; // Log de construção do programa
{$IFDEF CL_VERSION_2_0}
  PROGRAM_BINARY_TYPE    = $1184; // Tipo de binário do programa
{$ENDIF}
{$IFDEF CL_VERSION_2_1}
  PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE = $1185; // Tamanho total das variáveis globais na construção
{$ENDIF}

// Constantes de tipo de binário do programa
{$IFDEF CL_VERSION_2_0}
const
  PROGRAM_BINARY_TYPE_NONE            = $0;    // Nenhum binário
  PROGRAM_BINARY_TYPE_COMPILED_OBJECT = $1;    // Objeto compilado
  PROGRAM_BINARY_TYPE_LIBRARY         = $2;    // Biblioteca
  PROGRAM_BINARY_TYPE_EXECUTABLE      = $4;    // Executável
{$ENDIF}

// Constantes de informações do kernel
const
  KERNEL_FUNCTION_NAME   = $1190; // Nome da função do kernel
  KERNEL_NUM_ARGS        = $1191; // Número de argumentos do kernel
  KERNEL_REFERENCE_COUNT = $1192; // Contagem de referências do kernel
  KERNEL_CONTEXT         = $1193; // Contexto associado ao kernel
  KERNEL_PROGRAM         = $1194; // Programa associado ao kernel
{$IFDEF CL_VERSION_1_2}
  KERNEL_ATTRIBUTES      = $1195; // Atributos do kernel
{$ENDIF}

// Constantes de informações de grupo de trabalho do kernel
{$IFDEF CL_VERSION_1_1}
const
  KERNEL_WORK_GROUP_SIZE                   = $11B0; // Tamanho do grupo de trabalho
  KERNEL_COMPILE_WORK_GROUP_SIZE           = $11B1; // Tamanho do grupo de trabalho na compilação
  KERNEL_LOCAL_MEM_SIZE                    = $11B2; // Tamanho da memória local usada
  KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE = $11B3; // Múltiplo preferido do tamanho do grupo de trabalho
  KERNEL_PRIVATE_MEM_SIZE                  = $11B4; // Tamanho da memória privada usada
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  KERNEL_MAX_SUB_GROUP_SIZE_FOR_NDRANGE    = $2033; // Tamanho máximo de subgrupo para NDRange
  KERNEL_SUB_GROUP_COUNT_FOR_NDRANGE       = $2034; // Contagem de subgrupos para NDRange
{$ENDIF}

// Constantes de informações de argumento do kernel
{$IFDEF CL_VERSION_1_2}
const
  KERNEL_ARG_ADDRESS_QUALIFIER = $1196; // Qualificador de endereço do argumento
  KERNEL_ARG_ACCESS_QUALIFIER  = $1197; // Qualificador de acesso do argumento
  KERNEL_ARG_TYPE_NAME         = $1198; // Nome do tipo do argumento
  KERNEL_ARG_TYPE_QUALIFIER    = $1199; // Qualificador de tipo do argumento
  KERNEL_ARG_NAME              = $119A; // Nome do argumento
{$ENDIF}

// Constantes de qualificador de endereço do argumento
{$IFDEF CL_VERSION_1_2}
const
  KERNEL_ARG_ADDRESS_GLOBAL   = $119B; // Endereço global
  KERNEL_ARG_ADDRESS_LOCAL    = $119C; // Endereço local
  KERNEL_ARG_ADDRESS_CONSTANT = $119D; // Endereço constante
  KERNEL_ARG_ADDRESS_PRIVATE  = $119E; // Endereço privado
{$ENDIF}

// Constantes de qualificador de acesso do argumento
{$IFDEF CL_VERSION_1_2}
const
  KERNEL_ARG_ACCESS_READ_ONLY  = $11A0; // Somente leitura
  KERNEL_ARG_ACCESS_WRITE_ONLY = $11A1; // Somente escrita
  KERNEL_ARG_ACCESS_READ_WRITE = $11A2; // Leitura e escrita
  KERNEL_ARG_ACCESS_NONE       = $11A3; // Sem acesso
{$ENDIF}

// Constantes de qualificador de tipo do argumento
{$IFDEF CL_VERSION_1_2}
const
  KERNEL_ARG_TYPE_NONE         = 0;        // Nenhum qualificador
  KERNEL_ARG_TYPE_CONST        = (1 shl 0); // Constante
  KERNEL_ARG_TYPE_RESTRICT     = (1 shl 1); // Restrito
  KERNEL_ARG_TYPE_VOLATILE     = (1 shl 2); // Volátil
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  KERNEL_ARG_TYPE_PIPE         = (1 shl 3); // Pipe
{$ENDIF}

// Constantes de informações de eventos
const
  EVENT_COMMAND_QUEUE         = $11D0; // Fila de comandos associada ao evento
  EVENT_COMMAND_TYPE          = $11D1; // Tipo de comando gerador do evento
  EVENT_REFERENCE_COUNT       = $11D2; // Contagem de referências do evento
  EVENT_COMMAND_EXECUTION_STATUS = $11D3; // Status de execução do comando
  EVENT_CONTEXT               = $11D4; // Contexto associado ao evento
{$IFDEF CL_VERSION_2_1}
  EVENT_COMMAND_START         = $11D5; // Tempo de início do comando
  EVENT_COMMAND_END           = $11D6; // Tempo de término do comando
{$ENDIF}

// Constantes de status de execução do evento
const
  COMPLETE = $0; // Comando concluído
  RUNNING  = $1; // Comando em execução
  SUBMITTED = $2; // Comando submetido
  QUEUED   = $3; // Comando enfileirado

// Constantes de tipo de comando de callback de evento
{$IFDEF CL_VERSION_1_1}
const
  COMMAND_COMPLETE = $0; // Callback ao completar
{$ENDIF}

// Constantes de informações do amostrador
const
  SAMPLER_REFERENCE_COUNT   = $1150; // Contagem de referências do amostrador
  SAMPLER_CONTEXT           = $1151; // Contexto associado ao amostrador
  SAMPLER_NORMALIZED_COORDS = $1152; // Coordenadas normalizadas (verdadeiro/falso)
  SAMPLER_ADDRESSING_MODE   = $1153; // Modo de endereçamento do amostrador
  SAMPLER_FILTER_MODE       = $1154; // Modo de filtro do amostrador
{$IFDEF CL_VERSION_2_0}
  SAMPLER_MIP_FILTER_MODE   = $1155; // Modo de filtro MIP
  SAMPLER_LOD_MIN           = $1156; // Nível de detalhe (LOD) mínimo
  SAMPLER_LOD_MAX           = $1157; // Nível de detalhe (LOD) máximo
{$ENDIF}

// Constantes de modo de endereçamento
const
  ADDRESS_NONE            = $1130; // Nenhum modo de endereçamento (retorna borda)
  ADDRESS_CLAMP_TO_EDGE   = $1131; // Fixar na borda da imagem
  ADDRESS_CLAMP           = $1132; // Fixar fora da imagem
  ADDRESS_REPEAT          = $1133; // Repetir a imagem
{$IFDEF CL_VERSION_1_1}
  ADDRESS_MIRRORED_REPEAT = $1134; // Repetir a imagem espelhada
{$ENDIF}

// Constantes de modo de filtro
const
  FILTER_NEAREST = $1140; // Filtro mais próximo
  FILTER_LINEAR  = $1141; // Filtro linear

// Constantes de tipo de comando
const
  COMMAND_NDRANGE_KERNEL     = $11F0; // Comando de execução de kernel NDRange
  COMMAND_TASK               = $11F1; // Comando de tarefa
  COMMAND_NATIVE_KERNEL      = $11F2; // Comando de kernel nativo
  COMMAND_READ_BUFFER        = $11F3; // Comando de leitura de buffer
  COMMAND_WRITE_BUFFER       = $11F4; // Comando de escrita de buffer
  COMMAND_COPY_BUFFER        = $11F5; // Comando de cópia de buffer
  COMMAND_READ_IMAGE         = $11F6; // Comando de leitura de imagem
  COMMAND_WRITE_IMAGE        = $11F7; // Comando de escrita de imagem
  COMMAND_COPY_IMAGE         = $11F8; // Comando de cópia de imagem
  COMMAND_COPY_IMAGE_TO_BUFFER = $11F9; // Comando de cópia de imagem para buffer
  COMMAND_COPY_BUFFER_TO_IMAGE = $11FA; // Comando de cópia de buffer para imagem
  COMMAND_MAP_BUFFER         = $11FB; // Comando de mapeamento de buffer
  COMMAND_MAP_IMAGE          = $11FC; // Comando de mapeamento de imagem
  COMMAND_UNMAP_MEM_OBJECT   = $11FD; // Comando de desmapeamento de objeto de memória
  COMMAND_MARKER             = $11FE; // Comando de marcador
  COMMAND_ACQUIRE_GL_OBJECTS = $11FF; // Comando de aquisição de objetos GL
  COMMAND_RELEASE_GL_OBJECTS = $1200; // Comando de liberação de objetos GL
{$IFDEF CL_VERSION_1_1}
  COMMAND_READ_BUFFER_RECT   = $1201; // Comando de leitura de buffer retangular
  COMMAND_WRITE_BUFFER_RECT  = $1202; // Comando de escrita de buffer retangular
  COMMAND_COPY_BUFFER_RECT   = $1203; // Comando de cópia de buffer retangular
  COMMAND_USER               = $1204; // Comando de usuário
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  COMMAND_BARRIER            = $1205; // Comando de barreira
  COMMAND_MIGRATE_MEM_OBJECTS = $1206; // Comando de migração de objetos de memória
  COMMAND_FILL_BUFFER        = $1207; // Comando de preenchimento de buffer
  COMMAND_FILL_IMAGE         = $1208; // Comando de preenchimento de imagem
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  COMMAND_SVM_FREE           = $1209; // Comando de liberação de SVM
  COMMAND_SVM_MEMCPY         = $120A; // Comando de cópia de memória SVM
  COMMAND_SVM_MEMFILL        = $120B; // Comando de preenchimento de memória SVM
  COMMAND_SVM_MAP            = $120C; // Comando de mapeamento de SVM
  COMMAND_SVM_UNMAP          = $120D; // Comando de desmapeamento de SVM
{$ENDIF}

// Constantes de tipo de buffer
{$IFDEF CL_VERSION_1_1}
const
  BUFFER_CREATE_TYPE_REGION = $1220; // Tipo de criação de região de buffer
{$ENDIF}

// Constantes de tipo de imagem
type
  Tcl_image_format = record
    image_channel_order: Tcl_uint;     // Ordem dos canais da imagem
    image_channel_data_type: Tcl_uint; // Tipo de dados dos canais da imagem
  end;
  Pcl_image_format = ^Tcl_image_format; // Ponteiro para formato de imagem

  Tcl_image_desc = record
    image_type: Tcl_mem_object_type;   // Tipo de imagem
    image_width: Tcl_size_t;           // Largura da imagem
    image_height: Tcl_size_t;          // Altura da imagem
    image_depth: Tcl_size_t;           // Profundidade da imagem
    image_array_size: Tcl_size_t;      // Tamanho do array de imagens
    image_row_pitch: Tcl_size_t;       // Pitch da linha da imagem
    image_slice_pitch: Tcl_size_t;     // Pitch da fatia da imagem
    num_mip_levels: Tcl_uint;          // Número de níveis MIP
    num_samples: Tcl_uint;             // Número de amostras
    buffer: Tcl_mem;                   // Buffer associado (se aplicável)
  end;
  Pcl_image_desc = ^Tcl_image_desc;    // Ponteiro para descrição de imagem

// Constantes de tipo de objeto de memória
const
  MEM_OBJECT_BUFFER         = $10F0; // Buffer
  MEM_OBJECT_IMAGE2D        = $10F1; // Imagem 2D
  MEM_OBJECT_IMAGE3D        = $10F2; // Imagem 3D
{$IFDEF CL_VERSION_1_2}
  MEM_OBJECT_IMAGE2D_ARRAY  = $10F3; // Array de imagens 2D
  MEM_OBJECT_IMAGE1D        = $10F4; // Imagem 1D
  MEM_OBJECT_IMAGE1D_ARRAY  = $10F5; // Array de imagens 1D
  MEM_OBJECT_IMAGE1D_BUFFER = $10F6; // Buffer de imagem 1D
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  MEM_OBJECT_PIPE           = $10F7; // Pipe
{$ENDIF}

// Constantes de ordem de canal de imagem
const
  CL_R               = $10B0; // Canal vermelho
  CL_A               = $10B1; // Canal alfa
  CL_RG              = $10B2; // Canais vermelho e verde
  CL_RA              = $10B3; // Canais vermelho e alfa
  CL_RGB             = $10B4; // Canais vermelho, verde e azul
  CL_RGBA            = $10B5; // Canais vermelho, verde, azul e alfa
  CL_BGRA            = $10B6; // Canais azul, verde, vermelho e alfa
  CL_ARGB            = $10B7; // Canais alfa, vermelho, verde e azul
  CL_INTENSITY       = $10B8; // Intensidade
  CL_LUMINANCE       = $10B9; // Luminância
{$IFDEF CL_VERSION_1_1}
  CL_Rx              = $10BA; // Canal vermelho estendido
  CL_RGx             = $10BB; // Canais vermelho e verde estendidos
  CL_RGBx            = $10BC; // Canais vermelho, verde e azul estendidos
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  CL_DEPTH           = $10BD; // Profundidade
  CL_DEPTH_STENCIL   = $10BE; // Profundidade e estêncil
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  CL_sRGB            = $10BF; // RGB em espaço sRGB
  CL_sRGBx           = $10C0; // RGB estendido em sRGB
  CL_sRGBA           = $10C1; // RGBA em sRGB
  CL_sBGRA           = $10C2; // BGRA em sRGB
  CL_ABGR            = $10C3; // Canais alfa, azul, verde e vermelho
{$ENDIF}

// Constantes de tipo de dados de canal de imagem
const
  CL_SNORM_INT8       = $10D0; // Inteiro assinado normalizado de 8 bits
  CL_SNORM_INT16      = $10D1; // Inteiro assinado normalizado de 16 bits
  CL_UNORM_INT8       = $10D2; // Inteiro não assinado normalizado de 8 bits
  CL_UNORM_INT16      = $10D3; // Inteiro não assinado normalizado de 16 bits
  CL_UNORM_SHORT_565  = $10D4; // Formato RGB 5-6-5 não assinado
  CL_UNORM_SHORT_555  = $10D5; // Formato RGB 5-5-5 não assinado
  CL_UNORM_INT_101010 = $10D6; // Formato RGB 10-10-10 não assinado
  CL_SIGNED_INT8      = $10D7; // Inteiro assinado de 8 bits
  CL_SIGNED_INT16     = $10D8; // Inteiro assinado de 16 bits
  CL_SIGNED_INT32     = $10D9; // Inteiro assinado de 32 bits
  CL_UNSIGNED_INT8    = $10DA; // Inteiro não assinado de 8 bits
  CL_UNSIGNED_INT16   = $10DB; // Inteiro não assinado de 16 bits
  CL_UNSIGNED_INT32   = $10DC; // Inteiro não assinado de 32 bits
  CL_HALF_FLOAT       = $10DD; // Ponto flutuante de 16 bits (half)
  CL_FLOAT            = $10DE; // Ponto flutuante de 32 bits
{$IFDEF CL_VERSION_1_2}
  CL_UNORM_INT24      = $10DF; // Inteiro não assinado normalizado de 24 bits
{$ENDIF}
{$IFDEF CL_VERSION_2_0}
  CL_UNORM_INT_101010_2 = $10E0; // Formato RGB 10-10-10-2 não assinado
{$ENDIF}

// Constantes de tipo de ponto flutuante
const
  FP_DENORM          = (1 shl 0); // Suporte a denormalizados
  FP_INF_NAN         = (1 shl 1); // Suporte a infinito e NaN
  FP_ROUND_TO_NEAREST = (1 shl 2); // Arredondamento para o mais próximo
  FP_ROUND_TO_ZERO   = (1 shl 3); // Arredondamento para zero
  FP_ROUND_TO_INF    = (1 shl 4); // Arredondamento para infinito
  FP_FMA             = (1 shl 5); // Suporte a multiplicação e adição fundidas
{$IFDEF CL_VERSION_1_1}
  FP_SOFT_FLOAT      = (1 shl 6); // Implementação de ponto flutuante em software
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  FP_CORRECTLY_ROUNDED_DIVIDE_SQRT = (1 shl 7); // Divisão e raiz quadrada corretamente arredondadas
{$ENDIF}

// Constantes de tipo de cache de memória global
const
  NONE               = $0; // Nenhum cache
  READ_ONLY_CACHE    = $1; // Cache somente de leitura
  READ_WRITE_CACHE   = $2; // Cache de leitura e escrita

// Constantes de tipo de memória local
const
  LOCAL              = $1; // Memória local dedicada
  GLOBAL             = $2; // Memória global usada como local

// Constantes de capacidades de execução
const
  EXEC_KERNEL        = (1 shl 0); // Suporte a execução de kernels OpenCL
  EXEC_NATIVE_KERNEL = (1 shl 1); // Suporte a execução de kernels nativos

// Constantes de tipo de partição de dispositivo
{$IFDEF CL_VERSION_1_2}
const
  DEVICE_PARTITION_EQUALLY            = $1086; // Partição igual
  DEVICE_PARTITION_BY_COUNTS          = $1087; // Partição por contagens
  DEVICE_PARTITION_BY_AFFINITY_DOMAIN = $1088; // Partição por domínio de afinidade
{$ENDIF}

// Constantes de domínio de afinidade de partição
{$IFDEF CL_VERSION_1_2}
const
  DEVICE_AFFINITY_DOMAIN_NUMA               = (1 shl 0); // Domínio NUMA
  DEVICE_AFFINITY_DOMAIN_L4_CACHE           = (1 shl 1); // Cache L4
  DEVICE_AFFINITY_DOMAIN_L3_CACHE           = (1 shl 2); // Cache L3
  DEVICE_AFFINITY_DOMAIN_L2_CACHE           = (1 shl 3); // Cache L2
  DEVICE_AFFINITY_DOMAIN_L1_CACHE           = (1 shl 4); // Cache L1
  DEVICE_AFFINITY_DOMAIN_NEXT_PARTITIONABLE = (1 shl 5); // Próximo nível particionável
{$ENDIF}

// Constantes de tipo de objeto GL
{$IFDEF CL_VERSION_1_2}
const
  GL_OBJECT_BUFFER         = $2000; // Buffer GL
  GL_OBJECT_TEXTURE2D      = $2001; // Textura 2D GL
  GL_OBJECT_TEXTURE3D      = $2002; // Textura 3D GL
  GL_OBJECT_RENDERBUFFER   = $2003; // Renderbuffer GL
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  GL_OBJECT_TEXTURE2D_ARRAY = $2004; // Array de texturas 2D GL
  GL_OBJECT_TEXTURE1D       = $2005; // Textura 1D GL
  GL_OBJECT_TEXTURE1D_ARRAY = $2006; // Array de texturas 1D GL
  GL_OBJECT_TEXTURE_BUFFER  = $2007; // Buffer de textura GL
{$ENDIF}

// Constantes de informações de textura GL
{$IFDEF CL_VERSION_1_2}
const
  GL_TEXTURE_TARGET = $2008; // Alvo da textura GL
  GL_MIPMAP_LEVEL   = $2009; // Nível de mipmap GL
{$ENDIF}
{$IFDEF CL_VERSION_1_2}
  GL_NUM_SAMPLES    = $2010; // Número de amostras GL
{$ENDIF}

// Constantes de capacidades SVM
{$IFDEF CL_VERSION_2_0}
const
  SVM_COARSE_GRAIN_BUFFER = (1 shl 0); // Buffer de grão grosso SVM
  SVM_FINE_GRAIN_BUFFER   = (1 shl 1); // Buffer de grão fino SVM
  SVM_FINE_GRAIN_SYSTEM   = (1 shl 2); // Sistema de grão fino SVM
  SVM_ATOMICS             = (1 shl 3); // Suporte a operações atômicas SVM
{$ENDIF}

// Constantes de flags de migração de memória
{$IFDEF CL_VERSION_1_2}
const
  MEM_MIGRATION_FLAGS_HOST = (1 shl 0); // Migrar para o host
{$ENDIF}

// Constantes de informações de pipe
{$IFDEF CL_VERSION_2_0}
const
  PIPE_PACKET_SIZE = $1120; // Tamanho do pacote do pipe
  PIPE_MAX_PACKETS = $1121; // Número máximo de pacotes do pipe
{$ENDIF}
{$IFDEF CL_VERSION_3_0}
  PIPE_PROPERTIES  = $1122; // Propriedades do pipe
{$ENDIF}

// Constantes de informações de execução do kernel
{$IFDEF CL_VERSION_2_0}
const
  KERNEL_EXEC_INFO_SVM_PTRS = $11B6; // Ponteiros SVM usados pelo kernel
  KERNEL_EXEC_INFO_SVM_FINE_GRAIN_SYSTEM = $11B7; // Uso de SVM de grão fino do sistema
{$ENDIF}

// Constantes de informações de callback de evento
{$IFDEF CL_VERSION_2_0}
const
  COMMAND_SVM_FREE_EVENT = $120E; // Evento de liberação de SVM
{$ENDIF}

// Constantes de classe Platform (equivalente a cl::Platform)
type
  TCLPlatform = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(platform: Tcl_platform_id); overload; // Construtor com ID da plataforma
    constructor Create(const platform: TCLPlatform); overload; // Construtor de cópia
    destructor Destroy; override; // Destrutor

    function Assign(const rhs: TCLPlatform): TCLPlatform; // Operador de atribuição
    function GetInfo(name: Tcl_platform_info; param: PString): Tcl_int; // Obtém informação da plataforma
    function GetDevices(device_type: Tcl_device_type; devices: PArray<TCLDevice>): Tcl_int; // Obtém dispositivos da plataforma
    function Get: Tcl_platform_id; // Retorna o ID da plataforma

    function IsEqual(const rhs: TCLPlatform): Boolean; // Operador de igualdade (==)
    function IsNotEqual(const rhs: TCLPlatform): Boolean; // Operador de desigualdade (!=)

    class function Get(platforms: PArray<TCLPlatform>): Tcl_int; static; // Obtém todas as plataformas disponíveis

  private
    FPlatform: Tcl_platform_id; // ID da plataforma OpenCL
  end;

// Classe Device (equivalente a cl::Device)
type
  TCLDevice = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(device: Tcl_device_id); overload; // Construtor com ID do dispositivo
    constructor Create(const device: TCLDevice); overload; // Construtor de cópia
    destructor Destroy; override; // Destrutor

    function Assign(const rhs: TCLDevice): TCLDevice; // Operador de atribuição
    function GetInfo(name: Tcl_device_info; param: PString): Tcl_int; // Obtém informação do dispositivo
    function Get: Tcl_device_id; // Retorna o ID do dispositivo
    function GetPlatform(platform: TCLPlatform): Tcl_int; // Obtém a plataforma associada

  private
    FDevice: Tcl_device_id; // ID do dispositivo OpenCL
  end;

// Classe Context (equivalente a cl::Context)
type
  TCLContext = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(const properties: array of Tcl_context_properties; num_devices: Tcl_uint; devices: Pcl_device_id;
      pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall; user_data: Pointer); overload; // Construtor completo
    constructor Create(device_type: Tcl_device_type; pfn_notify: procedure(errinfo: PAnsiChar; private_info: Pointer; cb: Tcl_size_t; user_data: Pointer); stdcall; user_data: Pointer); overload; // Construtor por tipo de dispositivo
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_context_info; param_value: PString): Tcl_int; // Obtém informação do contexto
    function Get: Tcl_context; // Retorna o contexto

  private
    FContext: Tcl_context; // Contexto OpenCL
  end;

// Classe CommandQueue (equivalente a cl::CommandQueue)
type
  TCLCommandQueue = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(context: TCLContext; device: TCLDevice; properties: Tcl_queue_properties); overload; // Construtor completo
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_command_queue_info; param_value: PString): Tcl_int; // Obtém informação da fila
    function Get: Tcl_command_queue; // Retorna a fila de comandos
    function Finish: Tcl_int; // Finaliza todos os comandos na fila
    function Flush: Tcl_int; // Garante que todos os comandos sejam enviados

  private
    FQueue: Tcl_command_queue; // Fila de comandos OpenCL
  end;

// Classe Program (equivalente a cl::Program)
type
  TCLProgram = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(context: TCLContext; count: Tcl_uint; strings: PPAnsiChar; lengths: Pcl_size_t); overload; // Construtor com fonte
    constructor Create(context: TCLContext; devices: PArray<TCLDevice>; lengths: Pcl_size_t; binaries: PPcl_uchar; binary_status: Pcl_int); overload; // Construtor com binário
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_program_info; param_value: PString): Tcl_int; // Obtém informação do programa
    function GetBuildInfo(device: TCLDevice; param_name: Tcl_program_build_info; param_value: PString): Tcl_int; // Obtém informação de construção
    function Build(devices: PArray<TCLDevice>; options: PAnsiChar; pfn_notify: procedure(aprogram: Tcl_program; user_data: Pointer); stdcall; user_data: Pointer): Tcl_int; // Constrói o programa
    function Get: Tcl_program; // Retorna o programa

  private
    Faprogram: Tcl_program; // Programa OpenCL
  end;

// Classe Kernel (equivalente a cl::Kernel)
type
  TCLKernel = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(aprogram: TCLProgram; kernel_name: PAnsiChar); overload; // Construtor com nome do kernel
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_kernel_info; param_value: PString): Tcl_int; // Obtém informação do kernel
    function SetArg(arg_index: Tcl_uint; arg_size: Tcl_size_t; arg_value: Pointer): Tcl_int; // Define argumento do kernel
    function Get: Tcl_kernel; // Retorna o kernel

  private
    FKernel: Tcl_kernel; // Kernel OpenCL
  end;

// Classe Memory (equivalente a cl::Memory)
type
  TCLMemory = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(context: TCLContext; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer); overload; // Construtor com buffer
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_mem_info; param_value: PString): Tcl_int; // Obtém informação da memória
    function Get: Tcl_mem; // Retorna o objeto de memória

  private
    FMemory: Tcl_mem; // Objeto de memória OpenCL
  end;

// Classe Buffer (equivalente a cl::Buffer)
type
  TCLBuffer = class(TCLMemory)
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(context: TCLContext; flags: Tcl_mem_flags; size: Tcl_size_t; host_ptr: Pointer); overload; // Construtor com buffer
    destructor Destroy; override; // Destrutor
  end;

// Classe Event (equivalente a cl::Event)
type
  TCLEvent = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(context: TCLContext); overload; // Construtor com contexto (usuário)
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_event_info; param_value: PString): Tcl_int; // Obtém informação do evento
    function Get: Tcl_event; // Retorna o evento
    function Wait: Tcl_int; // Aguarda conclusão do evento

  private
    FEvent: Tcl_event; // Evento OpenCL
  end;

// Classe Sampler (equivalente a cl::Sampler)
type
  TCLSampler = class
  public
    constructor Create; overload; // Construtor padrão
    constructor Create(context: TCLContext; normalized_coords: Tcl_bool; addressing_mode: Tcl_addressing_mode; filter_mode: Tcl_filter_mode); overload; // Construtor completo
    destructor Destroy; override; // Destrutor

    function GetInfo(param_name: Tcl_sampler_info; param_value: PString): Tcl_int; // Obtém informação do amostrador
    function Get: Tcl_sampler; // Retorna o amostrador

  private
    FSampler: Tcl_sampler; // Amostrador OpenCL
  end;

// Funções utilitárias inline
function GetPlatforms(platforms: PArray<TCLPlatform>): Tcl_int; // Obtém todas as plataformas disponíveis
function GetDevices(const platform: TCLPlatform; device_type: Tcl_device_type; devices: PArray<TCLDevice>): Tcl_int; // Obtém dispositivos da plataforma

// Tratamento de extensões
const
  EXTENSION_SUFFIX = '_cl_khr'; // Sufixo padrão para extensões OpenCL
  EXTENSION_LIST: array[0..7] of PAnsiChar = (
    'cl_khr_fp64',            // Suporte a ponto flutuante de 64 bits
    'cl_khr_fp16',            // Suporte a ponto flutuante de 16 bits
    'cl_khr_gl_sharing',      // Compartilhamento com OpenGL
    'cl_khr_gl_event',        // Eventos OpenGL
    'cl_khr_d3d10_sharing',   // Compartilhamento com Direct3D 10
    'cl_khr_d3d11_sharing',   // Compartilhamento com Direct3D 11
    'cl_khr_dx9_media_sharing', // Compartilhamento com DirectX 9 Media
    nil                       // Marca o fim da lista
  );

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
    CL_INVALID_aprogram: Result := 'Invalid Program';
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

// Implementação da classe TCLPlatform
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

// Implementação da classe TCLDevice
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

function TCLProgram.Build(devices: PArray<TCLDevice>; options: PAnsiChar; pfn_notify: procedure(aprogram: Tcl_program; user_data: Pointer); stdcall; user_data: Pointer): Tcl_int;
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

constructor TCLKernel.Create(aprogram: TCLProgram; kernel_name: PAnsiChar);
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

end.