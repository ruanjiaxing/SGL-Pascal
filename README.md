# SGL-Pascal
Small GUI Library (or Simple Graphic Layer) binding for Pascal

SGL is a small GUI library developed for Windows GUI development with Pelles C by Henri Serindat.

Check it here: <http://perso.numericable.fr/hserindat/sgl/>

Even though it's developed for Pelles C the code is very portable. To obtain the code, you could contact Henri at hserindat@gmail.com

In other to get the code to build with MinGW, you have to apply the following fixes:

1. You have to define WINVER and _WIN32_WINNT in the beginning of sgl_debug.c

2. You have to replace "gl/gl.h" with "GL/gl.h" in sgl_opengl.c

3. You have to link with kernel32, user32, gdi32, gdiplus, msimg32, shlwapi, opengl32, glu32, comctl32, advapi32.

In case you just use the DLLs provided by sgldllkit, you could create the import library for MinGW using the .def file and MinGW's dlltool.

In my binding, I merged all of sgl headers to one header sgl.h and commented out all of the macros on sgl_debug.h because I can't accurately translate them to Pascal. These macros are not mandatory, but very useful if you develop with SGL in C, though. With Pascal, you can use proper exception handling feature of the language.
