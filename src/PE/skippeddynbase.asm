; a PE with ignored DYNAMIC_BASE, because RELOCS_STRIPPED is set
; (otherwise it would fail loading)

; Ange Albertini, BSD LICENCE 2013

%include 'consts.inc'

IMAGEBASE equ 400000h
org IMAGEBASE
bits 32

SECTIONALIGN equ 1000h
FILEALIGN equ 200h

istruc IMAGE_DOS_HEADER
    at IMAGE_DOS_HEADER.e_magic,  db 'MZ'
    at IMAGE_DOS_HEADER.e_lfanew, dd NT_Headers - IMAGEBASE
iend

NT_Headers:
istruc IMAGE_NT_HEADERS
    at IMAGE_NT_HEADERS.Signature, db 'PE', 0, 0
iend
istruc IMAGE_FILE_HEADER
    at IMAGE_FILE_HEADER.Machine,              dw IMAGE_FILE_MACHINE_I386
    at IMAGE_FILE_HEADER.NumberOfSections,     dw NUMBEROFSECTIONS
    at IMAGE_FILE_HEADER.SizeOfOptionalHeader, dw SIZEOFOPTIONALHEADER
    at IMAGE_FILE_HEADER.Characteristics,      dw IMAGE_FILE_EXECUTABLE_IMAGE | IMAGE_FILE_32BIT_MACHINE | IMAGE_FILE_RELOCS_STRIPPED ;<===
iend

OptionalHeader:
istruc IMAGE_OPTIONAL_HEADER32
    at IMAGE_OPTIONAL_HEADER32.Magic,                 dw IMAGE_NT_OPTIONAL_HDR32_MAGIC
    at IMAGE_OPTIONAL_HEADER32.AddressOfEntryPoint,   dd EntryPoint - IMAGEBASE
    at IMAGE_OPTIONAL_HEADER32.ImageBase,             dd IMAGEBASE
    at IMAGE_OPTIONAL_HEADER32.SectionAlignment,      dd SECTIONALIGN
    at IMAGE_OPTIONAL_HEADER32.FileAlignment,         dd FILEALIGN
    at IMAGE_OPTIONAL_HEADER32.MajorSubsystemVersion, dw 4
    at IMAGE_OPTIONAL_HEADER32.SizeOfImage,           dd 2 * SECTIONALIGN
    at IMAGE_OPTIONAL_HEADER32.SizeOfHeaders,         dd SIZEOFHEADERS
    at IMAGE_OPTIONAL_HEADER32.Subsystem,             dw IMAGE_SUBSYSTEM_WINDOWS_CUI
    at IMAGE_OPTIONAL_HEADER32.DllCharacteristics,    dw IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE ; <===
    at IMAGE_OPTIONAL_HEADER32.NumberOfRvaAndSizes,   dd 16
iend

%include 'dd_imports.inc'

%include 'section_1fa.inc'

%include 'code_printf.inc'

Msg db " * a PE with ignored DYNAMIC_BASE, because RELOCS_STRIPPED is set", 0ah, 0
_d

%include 'imports_printfexitprocess.inc'

align FILEALIGN, db 0
