@echo off
setlocal enabledelayedexpansion

REM Script para limpiar directorios FTP en Windows
REM Borra todo el contenido EXCEPTO los archivos del último día
REM Conserva archivos y directorios del día actual

set "RUTA_MENSAJES=E:\ftp\Mensajes"
set "RUTA_GRABACIONES=E:\ftp\Grabaciones"

echo ================================================
echo SCRIPT DE LIMPIEZA DE DIRECTORIOS FTP
echo ================================================
echo.
echo [INFO] Rutas a limpiar:
echo   - Mensajes: %RUTA_MENSAJES%
echo   - Grabaciones: %RUTA_GRABACIONES%
echo.
echo [INFO] Iniciando limpieza...
echo.

REM Función para limpiar directorio conservando último día
:limpiar_directorio
set "RUTA_DIR=%~1"
set "NOMBRE_DIR=%~2"

if not exist "!RUTA_DIR!" (
    echo [WARNING] El directorio !RUTA_DIR! no existe. Se omite.
    goto :eof
)

echo [INFO] Limpiando !NOMBRE_DIR! (conservando archivos del último día)...
cd /d "!RUTA_DIR!"

REM Borrar archivos más antiguos que hoy
REM forfiles /d -1 borra archivos modificados hace más de 1 día
REM Esto conserva archivos modificados hoy (último día)
forfiles /p "!RUTA_DIR!" /m *.* /d -1 /c "cmd /c del /f /q @path" >nul 2>&1

REM Limpiar subdirectorios recursivamente
if exist * (
    for /d %%d in (*) do (
        REM Limpiar archivos antiguos dentro del subdirectorio (recursivo)
        forfiles /p "!RUTA_DIR!\%%d" /s /m *.* /d -1 /c "cmd /c del /f /q @path" >nul 2>&1
        
        REM Verificar si el subdirectorio quedó vacío después de limpiar
        pushd "%%d" >nul 2>&1
        if !errorlevel! equ 0 (
            set "TIENE_CONTENIDO=0"
            for %%f in (*.*) do set "TIENE_CONTENIDO=1"
            for /d %%s in (*) do set "TIENE_CONTENIDO=1"
            popd
            if !TIENE_CONTENIDO! equ 0 (
                rd /s /q "%%d" >nul 2>&1
            )
        )
    )
)

echo [INFO] !NOMBRE_DIR! limpiado correctamente (archivos del último día conservados).
goto :eof

REM Limpiar directorio Mensajes
call :limpiar_directorio "%RUTA_MENSAJES%" "Mensajes"

REM Limpiar directorio Grabaciones
call :limpiar_directorio "%RUTA_GRABACIONES%" "Grabaciones"

echo.
echo [INFO] Limpieza completada.

