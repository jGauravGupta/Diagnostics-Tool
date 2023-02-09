@echo off
REM
REM  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
REM
REM  Copyright (c) 2021 Payara Foundation and/or its affiliates. All rights reserved.
REM
REM  The contents of this file are subject to the terms of either the GNU
REM  General Public License Version 2 only ("GPL") or the Common Development
REM  and Distribution License("CDDL") (collectively, the "License").  You
REM  may not use this file except in compliance with the License.  You can
REM  obtain a copy of the License at
REM  https://glassfish.dev.java.net/public/CDDL+GPL_1_1.html
REM  or packager/legal/LICENSE.txt.  See the License for the specific
REM  language governing permissions and limitations under the License.
REM
REM  When distributing the software, include this License Header Notice in each
REM  file and include the License file at packager/legal/LICENSE.txt.
REM
REM  GPL Classpath Exception:
REM  Oracle designates this particular file as subject to the "Classpath"
REM  exception as provided by Oracle in the GPL Version 2 section of the License
REM  file that accompanied this code.
REM
REM  Modifications:
REM  If applicable, add the following below the License Header, with the fields
REM  enclosed by brackets [] replaced by your own identifying information:
REM  "Portions Copyright [year] [name of copyright owner]"
REM
REM  Contributor(s):
REM  If you wish your version of this file to be governed by only the CDDL or
REM  only the GPL Version 2, indicate your decision by adding "[Contributor]
REM  elects to include this software in this distribution under the [CDDL or GPL
REM  Version 2] license."  If you don't indicate a single choice of license, a
REM  recipient has the option to distribute your version of this file under
REM  either the CDDL, the GPL Version 2 or to extend the choice of license to
REM  its licensees as provided above.  However, if you add GPL Version 2 code
REM  and therefore, elected the GPL Version 2 license, then the option applies
REM  only if the new code is made subject to such option by the copyright
REM  holder.
REM

VERIFY OTHER 2>nul
setlocal ENABLEEXTENSIONS
if ERRORLEVEL 0 goto sourceProperties
echo "Unable to enable extensions"
exit /B 1

:sourceProperties
if exist %~dp0..\config\upgrade-tool.bat (
    call "%~dp0..\config\upgrade-tool.bat"
) else (
    echo %~dp0..\config\upgrade-tool.bat not present! This is unexpected: Exiting since this implies you haven't yet run the upgrade-server command or have cleared it
    exit /B 1
)


for %%a in ("%PAYARA_UPGRADE_DIRS:,=" "%") do (
    REM Delete old dir
    if exist %~dp0..\%%a.old\* (
        echo Deleting old %%a
        rmdir /S /Q %~dp0..\%%a.old > nul
    )

    REM Delete old file
    if exist %~dp0..\%%a.old (
        echo Deleting old %%a
        del /S /Q %~dp0..\%%a.old > nul
    )

    REM Delete staged dir
    if exist %~dp0..\%%a.new\* (
        echo Deleting staged %%a
        rmdir /S /Q %~dp0..\%%a.new > nul
    )

    REM Delete staged file
    if exist %~dp0..\%%a.new (
        echo Deleting staged %%a
        del /S /Q %~dp0..\%%a.new > nul
    )
)

echo Deleting upgrade-tool property files
del /Q %~dp0..\config\upgrade-tool.bat
del /Q %~dp0..\config\upgrade-tool.properties