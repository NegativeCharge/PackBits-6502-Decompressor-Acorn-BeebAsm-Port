cd .\tests\
for %%x in (*.tsc) do del "%%x" 
for %%x in (*.bin) do ..\tools\packbits.exe "%%x" "%%~nx.bin.pkb"

cd ..
cmd /c "BeebAsm.exe -v -i packbits_test.s.asm -do packbits_test.ssd -opt 3"