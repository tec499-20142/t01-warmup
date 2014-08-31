Diretório de Arquivos de Simulação
==================================
Este diretório destina-se ao armazenamento de arquivos relacionados à simulação (arquivos de teste, testbenches, ambiente de verificação funcional, arquivos de waveform).

Organização de Subdiretórios
----------------------------
Sugere-se a organização dos subdiretórios da seguinte forma.

- sim/tb (arquivos de teste em verilog -- *testbench*);
- sim/ver (ambiente de verificação);
- sim/wave (arquivos de saída em forma de onda das ferramentas de simulação);
- sim/tests (estímulos gerados para realizações dos testes e simulações);

Cabeçalho dos arquivos Verilog de teste *testbenches*
-----------------------------------------------------
Cada arquivo de descrição de teste deve usar o padrão de cabeçalho fornecido (HEADER.*).
